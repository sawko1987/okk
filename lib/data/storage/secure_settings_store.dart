import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureKeyValueStore {
  const SecureKeyValueStore();

  Future<void> write({required String key, required String value});

  Future<String?> read({required String key});

  Future<void> delete({required String key});
}

class FlutterSecureKeyValueStore implements SecureKeyValueStore {
  const FlutterSecureKeyValueStore([
    this._storage = const FlutterSecureStorage(),
  ]);

  final FlutterSecureStorage _storage;

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }
}

class SecureSettingsStore {
  const SecureSettingsStore([
    this._storage = const FlutterSecureKeyValueStore(),
  ]);

  final SecureKeyValueStore _storage;

  static const _yandexDiskTokenKey = 'yandex_disk_token';

  Future<void> writeYandexDiskToken(String token) {
    final normalized = token.trim();
    if (normalized.isEmpty) {
      return deleteYandexDiskToken();
    }
    return _storage.write(key: _yandexDiskTokenKey, value: normalized);
  }

  Future<String?> readYandexDiskToken() {
    return _storage.read(key: _yandexDiskTokenKey);
  }

  Future<void> deleteYandexDiskToken() {
    return _storage.delete(key: _yandexDiskTokenKey);
  }
}
