import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/data/storage/secure_settings_store.dart';

void main() {
  test('stores normalized token values', () async {
    final backend = _MemorySecureKeyValueStore();
    final store = SecureSettingsStore(backend);

    await store.writeYandexDiskToken('  test-token  ');

    expect(await store.readYandexDiskToken(), 'test-token');
  });

  test('clears token when empty string is saved', () async {
    final backend = _MemorySecureKeyValueStore();
    final store = SecureSettingsStore(backend);

    await store.writeYandexDiskToken('token');
    await store.writeYandexDiskToken('   ');

    expect(await store.readYandexDiskToken(), isNull);
  });

  test('deletes token explicitly', () async {
    final backend = _MemorySecureKeyValueStore();
    final store = SecureSettingsStore(backend);

    await store.writeYandexDiskToken('token');
    await store.deleteYandexDiskToken();

    expect(await store.readYandexDiskToken(), isNull);
  });
}

class _MemorySecureKeyValueStore implements SecureKeyValueStore {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async {
    return _values[key];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }
}
