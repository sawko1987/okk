import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSettingsStore {
  const SecureSettingsStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _yandexDiskTokenKey = 'yandex_disk_token';

  Future<void> writeYandexDiskToken(String token) {
    return _storage.write(key: _yandexDiskTokenKey, value: token);
  }

  Future<String?> readYandexDiskToken() {
    return _storage.read(key: _yandexDiskTokenKey);
  }
}
