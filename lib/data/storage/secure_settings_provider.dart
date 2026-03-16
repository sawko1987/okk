import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'secure_settings_store.dart';

final secureSettingsStoreProvider = Provider<SecureSettingsStore>(
  (ref) => const SecureSettingsStore(),
);
