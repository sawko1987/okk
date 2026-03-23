import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../storage/secure_settings_provider.dart';
import '../storage/secure_settings_store.dart';

class SyncTransportException implements Exception {
  const SyncTransportException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class RemoteEntry {
  const RemoteEntry({
    required this.name,
    required this.path,
    required this.type,
  });

  final String name;
  final String path;
  final String type;
}

abstract class SyncTransport {
  Future<bool> isConfigured();

  Future<void> ensureRemoteLayout();

  Future<void> uploadFile({
    required String remotePath,
    required File file,
    String? contentType,
  });

  Future<void> uploadString({
    required String remotePath,
    required String content,
    String contentType = 'application/json; charset=utf-8',
  });

  Future<File> downloadFile({
    required String remotePath,
    required File destinationFile,
  });

  Future<String?> downloadString(String remotePath);

  Future<List<RemoteEntry>> listFiles(String remoteDirectory);

  Future<void> deletePath(String remotePath);
}

final syncTransportProvider = Provider<SyncTransport>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return YandexDiskTransport(
    secureSettingsStore: ref.watch(secureSettingsStoreProvider),
    client: client,
  );
});

class YandexDiskTransport implements SyncTransport {
  YandexDiskTransport({
    required SecureSettingsStore secureSettingsStore,
    required http.Client client,
  }) : _secureSettingsStore = secureSettingsStore,
       _client = client;

  final SecureSettingsStore _secureSettingsStore;
  final http.Client _client;

  static const _apiHost = 'cloud-api.yandex.net';
  static const _apiBasePath = '/v1/disk';
  static const remoteRoot = 'company_qc_app';

  @override
  Future<bool> isConfigured() async {
    final token = await _loadToken();
    return token != null;
  }

  @override
  Future<void> ensureRemoteLayout() async {
    final directories = [
      '',
      'manifest',
      'reference_data',
      'reference_data/packages',
      'reference_data/snapshots',
      'devices',
      'results',
      'results/incoming',
      'results/processed',
      'results/conflicts',
      'media',
      'media/components',
      'locks',
      'backup',
      'trash',
    ];

    for (final directory in directories) {
      await _createDirectory(_diskPath(directory));
    }
  }

  @override
  Future<void> uploadFile({
    required String remotePath,
    required File file,
    String? contentType,
  }) async {
    final token = await _requireToken();
    final uploadUri = Uri.https(_apiHost, '$_apiBasePath/resources/upload', {
      'path': _diskPath(remotePath),
      'overwrite': 'true',
    });
    final uploadMeta = await _sendJsonRequest(
      token: token,
      request: http.Request('GET', uploadUri),
      expectedStatusCodes: const {200, 201},
    );
    final href = uploadMeta['href'] as String?;
    if (href == null || href.isEmpty) {
      throw const SyncTransportException(
        'Яндекс.Диск не вернул ссылку для загрузки файла.',
      );
    }

    final request = http.Request(
      uploadMeta['method']?.toString() ?? 'PUT',
      Uri.parse(href),
    );
    if (contentType != null) {
      request.headers[HttpHeaders.contentTypeHeader] = contentType;
    }
    request.bodyBytes = await file.readAsBytes();

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw SyncTransportException(
        'Не удалось загрузить файл в Яндекс.Диск: '
        '$remotePath (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<void> uploadString({
    required String remotePath,
    required String content,
    String contentType = 'application/json; charset=utf-8',
  }) async {
    final tempFile = File(
      '${Directory.systemTemp.path}\\yandex_upload_${DateTime.now().microsecondsSinceEpoch}.tmp',
    );
    await tempFile.writeAsString(content);
    try {
      await uploadFile(
        remotePath: remotePath,
        file: tempFile,
        contentType: contentType,
      );
    } finally {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  @override
  Future<File> downloadFile({
    required String remotePath,
    required File destinationFile,
  }) async {
    final token = await _requireToken();
    final downloadUri = Uri.https(
      _apiHost,
      '$_apiBasePath/resources/download',
      {'path': _diskPath(remotePath)},
    );
    final downloadMeta = await _sendJsonRequest(
      token: token,
      request: http.Request('GET', downloadUri),
      expectedStatusCodes: const {200},
    );
    final href = downloadMeta['href'] as String?;
    if (href == null || href.isEmpty) {
      throw const SyncTransportException(
        'Яндекс.Диск не вернул ссылку для скачивания файла.',
      );
    }

    final response = await _client.get(Uri.parse(href));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw SyncTransportException(
        'Не удалось скачать файл из Яндекс.Диска: '
        '$remotePath (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }

    await destinationFile.parent.create(recursive: true);
    await destinationFile.writeAsBytes(response.bodyBytes, flush: true);
    return destinationFile;
  }

  @override
  Future<String?> downloadString(String remotePath) async {
    final token = await _loadToken();
    if (token == null) {
      return null;
    }

    final downloadUri = Uri.https(
      _apiHost,
      '$_apiBasePath/resources/download',
      {'path': _diskPath(remotePath)},
    );
    final request = http.Request('GET', downloadUri);
    final response = await _sendRequest(
      token: token,
      request: request,
      expectedStatusCodes: const {200, 404},
    );
    if (response.statusCode == 404) {
      return null;
    }

    final href =
        (jsonDecode(response.body) as Map<String, dynamic>)['href'] as String?;
    if (href == null || href.isEmpty) {
      return null;
    }

    final fileResponse = await _client.get(Uri.parse(href));
    if (fileResponse.statusCode == 404) {
      return null;
    }
    if (fileResponse.statusCode < 200 || fileResponse.statusCode >= 300) {
      throw SyncTransportException(
        'Не удалось скачать файл из Яндекс.Диска: '
        '$remotePath (${fileResponse.statusCode}).',
        statusCode: fileResponse.statusCode,
      );
    }
    return utf8.decode(fileResponse.bodyBytes);
  }

  @override
  Future<List<RemoteEntry>> listFiles(String remoteDirectory) async {
    final token = await _requireToken();
    final uri = Uri.https(_apiHost, '$_apiBasePath/resources', {
      'path': _diskPath(remoteDirectory),
      'limit': '1000',
    });
    final payload = await _sendJsonRequest(
      token: token,
      request: http.Request('GET', uri),
      expectedStatusCodes: const {200, 404},
    );
    final embedded = payload['_embedded'];
    if (embedded is! Map<String, dynamic>) {
      return const [];
    }
    final items = embedded['items'];
    if (items is! List) {
      return const [];
    }

    return items
        .whereType<Map>()
        .map(
          (item) => RemoteEntry(
            name: item['name']?.toString() ?? '',
            path: item['path']?.toString() ?? '',
            type: item['type']?.toString() ?? '',
          ),
        )
        .where((item) => item.name.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Future<void> deletePath(String remotePath) async {
    final token = await _requireToken();
    final uri = Uri.https(_apiHost, '$_apiBasePath/resources', {
      'path': _diskPath(remotePath),
      'permanently': 'true',
    });
    final response = await _sendRequest(
      token: token,
      request: http.Request('DELETE', uri),
      expectedStatusCodes: const {202, 204, 404},
    );
    if (response.statusCode == 404) {
      return;
    }
  }

  Future<void> _createDirectory(String diskPath) async {
    final token = await _requireToken();
    final uri = Uri.https(_apiHost, '$_apiBasePath/resources', {
      'path': diskPath,
    });
    await _sendRequest(
      token: token,
      request: http.Request('PUT', uri),
      expectedStatusCodes: const {201, 409},
    );
  }

  Future<Map<String, dynamic>> _sendJsonRequest({
    required String token,
    required http.Request request,
    required Set<int> expectedStatusCodes,
  }) async {
    final response = await _sendRequest(
      token: token,
      request: request,
      expectedStatusCodes: expectedStatusCodes,
    );
    if (response.body.isEmpty) {
      return <String, dynamic>{};
    }
    final payload = jsonDecode(response.body);
    if (payload is Map<String, dynamic>) {
      return payload;
    }
    return <String, dynamic>{};
  }

  Future<http.Response> _sendRequest({
    required String token,
    required http.Request request,
    required Set<int> expectedStatusCodes,
  }) async {
    request.headers[HttpHeaders.authorizationHeader] = 'OAuth $token';
    request.headers[HttpHeaders.acceptHeader] = 'application/json';
    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    if (!expectedStatusCodes.contains(response.statusCode)) {
      throw SyncTransportException(
        'Запрос к Яндекс.Диску завершился ошибкой: '
        '${response.statusCode}.',
        statusCode: response.statusCode,
      );
    }
    return response;
  }

  String _diskPath(String relativePath) {
    final trimmed = relativePath.trim().replaceAll('\\', '/');
    if (trimmed.isEmpty) {
      return 'disk:/$remoteRoot';
    }
    final normalized = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return 'disk:/$remoteRoot/$normalized';
  }

  Future<String?> _loadToken() async {
    final token = await _secureSettingsStore.readYandexDiskToken();
    final trimmed = token?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  Future<String> _requireToken() async {
    final token = await _loadToken();
    if (token == null) {
      throw const SyncTransportException('Токен Яндекс.Диска не настроен.');
    }
    return token;
  }
}
