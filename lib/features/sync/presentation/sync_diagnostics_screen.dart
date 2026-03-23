import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/bootstrap/bootstrap_data.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/platform/app_platform.dart';
import '../../../core/utils/user_message.dart';
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
    final inspectionDiagnostics = ref.watch(
      androidInspectionDiagnosticsProvider,
    );
    final syncDiagnostics = ref.watch(syncDiagnosticsProvider);
    final isAndroid =
        getAppPlatform() == AppPlatform.android && session != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Диагностика'),
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
                title: Text('Диагностика Android'),
                subtitle: Text(
                  'Используйте диагностику, чтобы проверить локальные справочные данные, очередь результатов и подключение к Яндекс.Диску перед работой.',
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _DiagnosticTile(
            title: 'Версия приложения',
            value: AppConstants.appVersion,
          ),
          _DiagnosticTile(
            title: 'Версия схемы базы данных',
            value: '${AppConstants.appSchemaVersion}',
          ),
          _DiagnosticTile(
            title: 'Версия схемы синхронизации',
            value: AppConstants.syncSchemaVersion,
          ),
          _DiagnosticTile(
            title: 'Путь к локальной базе данных',
            value: paths.databaseFile.path,
          ),
          _DiagnosticTile(
            title: 'Путь к файлу лога',
            value: paths.logFile.path,
          ),
          _DiagnosticTile(
            title: 'Логгер',
            value: bootstrap.logger.runtimeType.toString(),
          ),
          ...inspectionDiagnostics.when(
            data: (diagnostics) => [
              _DiagnosticTile(
                title: 'Локальные черновики проверок',
                value: '${diagnostics.localDraftCount}',
              ),
              _DiagnosticTile(
                title: 'Результаты проверок в очереди',
                value: '${diagnostics.queuedResultCount}',
              ),
              _DiagnosticTile(
                title: 'Ошибки в очереди синхронизации',
                value: '${diagnostics.failedQueueCount}',
              ),
              _DiagnosticTile(
                title: 'Конфликтные проверки',
                value: '${diagnostics.conflictCount}',
              ),
              _DiagnosticTile(
                title: 'Есть ожидающая синхронизация',
                value: diagnostics.hasPendingSyncWork ? 'Да' : 'Нет',
              ),
              _DiagnosticTile(
                title: 'Последний пакет справочников',
                value: diagnostics.lastReferencePackageId ?? 'Недоступно',
              ),
              _DiagnosticTile(
                title: 'Последняя синхронизация справочников',
                value: diagnostics.lastReferenceSyncAt ?? 'Недоступно',
              ),
              _DiagnosticTile(
                title: 'Последняя попытка синхронизации',
                value: diagnostics.lastSyncAttemptAt ?? 'Недоступно',
              ),
              _DiagnosticTile(
                title: 'Последняя завершенная проверка',
                value: diagnostics.lastCompletedInspectionAt ?? 'Недоступно',
              ),
            ],
            loading: () => const [
              _DiagnosticTile(
                title: 'Диагностика проверок',
                value: 'Загрузка...',
              ),
            ],
            error: (error, _) => [
              _DiagnosticTile(
                title: 'Диагностика проверок',
                value: userMessageFromError(
                  error,
                  fallback: 'Не удалось загрузить диагностику проверок.',
                ),
              ),
            ],
          ),
          ...syncDiagnostics.when(
            data: (diagnostics) => [
              _DiagnosticTile(
                title: 'Идентификатор устройства синхронизации',
                value: diagnostics.deviceId ?? 'Недоступно',
              ),
              _DiagnosticTile(
                title: 'Последняя отправка результата',
                value: diagnostics.lastResultPushAt ?? 'Недоступно',
              ),
              _DiagnosticTile(
                title: 'Последнее получение результата',
                value: diagnostics.lastResultPullAt ?? 'Недоступно',
              ),
              _DiagnosticTile(
                title: 'Последняя успешная синхронизация',
                value: diagnostics.lastSuccessAt ?? 'Недоступно',
              ),
              _DiagnosticTile(
                title: 'Последняя попытка синхронизации',
                value: diagnostics.lastSyncAttemptAt ?? 'Недоступно',
              ),
              _DiagnosticTile(
                title: 'Последний повторный запуск',
                value: diagnostics.lastRetryAt ?? 'Недоступно',
              ),
              _DiagnosticTile(
                title: 'Последний конфликт',
                value: diagnostics.lastConflictAt ?? 'Недоступно',
              ),
              _DiagnosticTile(
                title: 'Последняя ошибка синхронизации',
                value: diagnostics.lastError == null
                    ? 'Недоступно'
                    : userMessageFromText(
                        diagnostics.lastError,
                        fallback: 'Ошибка синхронизации.',
                      ),
              ),
              _DiagnosticTile(
                title: 'Ожидает отправки',
                value: '${diagnostics.pendingOutgoingCount}',
              ),
              _DiagnosticTile(
                title: 'Ожидает получения',
                value: '${diagnostics.pendingIncomingCount}',
              ),
              _DiagnosticTile(
                title: 'Ошибки очереди',
                value: '${diagnostics.failedQueueCount}',
              ),
              _DiagnosticTile(
                title: 'Элементы очереди, доступные для повтора',
                value: '${diagnostics.retryEligibleCount}',
              ),
              _DiagnosticTile(
                title: 'Количество конфликтов',
                value: '${diagnostics.conflictCount}',
              ),
              _DiagnosticTile(
                title: 'Токен Яндекс.Диска настроен',
                value: diagnostics.transportConfigured ? 'Да' : 'Нет',
              ),
              _DiagnosticTile(
                title: 'Подключение к Яндекс.Диску',
                value: diagnostics.yandexDiskConnected ? 'Да' : 'Нет',
              ),
            ],
            loading: () => const [
              _DiagnosticTile(
                title: 'Диагностика синхронизации',
                value: 'Загрузка...',
              ),
            ],
            error: (error, _) => [
              _DiagnosticTile(
                title: 'Диагностика синхронизации',
                value: userMessageFromError(
                  error,
                  fallback: 'Не удалось загрузить диагностику синхронизации.',
                ),
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
