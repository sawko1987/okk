import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/bootstrap/bootstrap_data.dart';
import '../../../core/config/app_constants.dart';
import '../../../data/storage/app_paths_provider.dart';

class SyncDiagnosticsScreen extends ConsumerWidget {
  const SyncDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapDataProvider);
    final paths = ref.watch(appPathsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Диагностика')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _DiagnosticTile(
            title: 'Версия приложения',
            value: AppConstants.appVersion,
          ),
          _DiagnosticTile(
            title: 'Версия схемы БД',
            value: '${AppConstants.appSchemaVersion}',
          ),
          _DiagnosticTile(
            title: 'Версия sync-схемы',
            value: AppConstants.syncSchemaVersion,
          ),
          _DiagnosticTile(
            title: 'Путь к локальной БД',
            value: paths.databaseFile.path,
          ),
          _DiagnosticTile(title: 'Путь к лог-файлу', value: paths.logFile.path),
          _DiagnosticTile(
            title: 'Logger',
            value: bootstrap.logger.runtimeType.toString(),
          ),
        ],
      ),
    );
  }
}

class _DiagnosticTile extends StatelessWidget {
  const _DiagnosticTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(title), subtitle: Text(value)),
    );
  }
}
