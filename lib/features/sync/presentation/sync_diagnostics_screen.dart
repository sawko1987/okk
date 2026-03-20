import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/bootstrap/bootstrap_data.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/platform/app_platform.dart';
import '../../../data/storage/app_paths_provider.dart';
import '../../../data/sync/sync_service.dart';
import '../../../ui/android_app_bar_actions.dart';
import '../../auth/data/auth_service.dart';
import '../../inspections/data/inspection_repositories.dart';

class SyncDiagnosticsScreen extends ConsumerWidget {
  const SyncDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapDataProvider);
    final paths = ref.watch(appPathsProvider);
    final session = ref.watch(activeSessionProvider).valueOrNull;
    final inspectionDiagnostics = ref.watch(androidInspectionDiagnosticsProvider);
    final syncDiagnostics = ref.watch(syncDiagnosticsProvider);
    final isAndroid =
        getAppPlatform() == AppPlatform.android && session != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostics'),
        actions: isAndroid
            ? buildAndroidAppBarActions(
                context: context,
                ref: ref,
                session: session,
              )
            : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (isAndroid) ...[
            const Card(
              child: ListTile(
                leading: Icon(Icons.monitor_heart_outlined),
                title: Text('Android diagnostics'),
                subtitle: Text(
                  'Use diagnostics to verify local reference data, queued results, and Yandex Disk connectivity before field work.',
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _DiagnosticTile(title: 'App version', value: AppConstants.appVersion),
          _DiagnosticTile(
            title: 'Database schema version',
            value: '${AppConstants.appSchemaVersion}',
          ),
          _DiagnosticTile(
            title: 'Sync schema version',
            value: AppConstants.syncSchemaVersion,
          ),
          _DiagnosticTile(
            title: 'Local database path',
            value: paths.databaseFile.path,
          ),
          _DiagnosticTile(title: 'Log file path', value: paths.logFile.path),
          _DiagnosticTile(
            title: 'Logger',
            value: bootstrap.logger.runtimeType.toString(),
          ),
          ...inspectionDiagnostics.when(
            data: (diagnostics) => [
              _DiagnosticTile(
                title: 'Local draft inspections',
                value: '${diagnostics.localDraftCount}',
              ),
              _DiagnosticTile(
                title: 'Queued inspection results',
                value: '${diagnostics.queuedResultCount}',
              ),
              _DiagnosticTile(
                title: 'Failed sync queue entries',
                value: '${diagnostics.failedQueueCount}',
              ),
              _DiagnosticTile(
                title: 'Conflict inspections',
                value: '${diagnostics.conflictCount}',
              ),
              _DiagnosticTile(
                title: 'Pending sync work',
                value: diagnostics.hasPendingSyncWork ? 'yes' : 'no',
              ),
              _DiagnosticTile(
                title: 'Last reference package',
                value: diagnostics.lastReferencePackageId ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Last reference sync',
                value: diagnostics.lastReferenceSyncAt ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Last sync attempt',
                value: diagnostics.lastSyncAttemptAt ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Last completed inspection',
                value: diagnostics.lastCompletedInspectionAt ?? 'not available',
              ),
            ],
            loading: () => const [
              _DiagnosticTile(
                title: 'Inspection diagnostics',
                value: 'loading...',
              ),
            ],
            error: (error, _) => [
              _DiagnosticTile(
                title: 'Inspection diagnostics',
                value: 'error: $error',
              ),
            ],
          ),
          ...syncDiagnostics.when(
            data: (diagnostics) => [
              _DiagnosticTile(
                title: 'Sync device id',
                value: diagnostics.deviceId ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Last result push',
                value: diagnostics.lastResultPushAt ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Last result pull',
                value: diagnostics.lastResultPullAt ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Last sync success',
                value: diagnostics.lastSuccessAt ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Last sync attempt',
                value: diagnostics.lastSyncAttemptAt ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Last retry run',
                value: diagnostics.lastRetryAt ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Last conflict',
                value: diagnostics.lastConflictAt ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Last sync error',
                value: diagnostics.lastError ?? 'not available',
              ),
              _DiagnosticTile(
                title: 'Pending outgoing queue',
                value: '${diagnostics.pendingOutgoingCount}',
              ),
              _DiagnosticTile(
                title: 'Pending incoming queue',
                value: '${diagnostics.pendingIncomingCount}',
              ),
              _DiagnosticTile(
                title: 'Failed queue entries',
                value: '${diagnostics.failedQueueCount}',
              ),
              _DiagnosticTile(
                title: 'Retry-eligible queue entries',
                value: '${diagnostics.retryEligibleCount}',
              ),
              _DiagnosticTile(
                title: 'Conflict count',
                value: '${diagnostics.conflictCount}',
              ),
              _DiagnosticTile(
                title: 'Yandex Disk token configured',
                value: diagnostics.transportConfigured ? 'yes' : 'no',
              ),
              _DiagnosticTile(
                title: 'Yandex Disk connected',
                value: diagnostics.yandexDiskConnected ? 'yes' : 'no',
              ),
            ],
            loading: () => const [
              _DiagnosticTile(title: 'Sync diagnostics', value: 'loading...'),
            ],
            error: (error, _) => [
              _DiagnosticTile(
                title: 'Sync diagnostics',
                value: 'error: $error',
              ),
            ],
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
