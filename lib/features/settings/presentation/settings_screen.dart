import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_constants.dart';
import '../../../data/storage/app_paths_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paths = ref.watch(appPathsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            title: const Text('Приложение'),
            subtitle: Text(AppConstants.appName),
          ),
          ListTile(
            title: const Text('Версия схемы БД'),
            subtitle: const Text('${AppConstants.appSchemaVersion}'),
          ),
          ListTile(
            title: const Text('Версия sync-схемы'),
            subtitle: const Text(AppConstants.syncSchemaVersion),
          ),
          ListTile(
            title: const Text('Корень локального хранилища'),
            subtitle: Text(paths.rootDir.path),
          ),
        ],
      ),
    );
  }
}
