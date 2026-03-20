import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_permissions.dart';
import '../../../core/platform/app_platform.dart';
import '../../../data/sync/sync_service.dart';
import '../../auth/data/auth_service.dart';
import '../../../data/storage/secure_settings_provider.dart';
import '../data/admin_repositories.dart';

class SyncAdminScreen extends ConsumerStatefulWidget {
  const SyncAdminScreen({super.key});

  @override
  ConsumerState<SyncAdminScreen> createState() => _SyncAdminScreenState();
}

class _SyncAdminScreenState extends ConsumerState<SyncAdminScreen> {
  late final TextEditingController _tokenController;
  bool _tokenLoaded = false;
  bool _isSyncing = false;
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tokenLoaded) {
      return;
    }
    _tokenLoaded = true;
    ref.read(secureSettingsStoreProvider).readYandexDiskToken().then((token) {
      if (!mounted) {
        return;
      }
      setState(() => _tokenController.text = token ?? '');
    });
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queueAsync = ref.watch(syncQueueEntriesProvider);
    final deviceAsync = ref.watch(deviceInfoProvider);
    final syncDiagnosticsAsync = ref.watch(syncDiagnosticsProvider);
    final auditEntriesAsync = ref.watch(auditEntriesProvider);
    final session = ref.watch(activeSessionProvider).valueOrNull;
    final actorUserId = session?.userId;
    final canEdit = roleHasCapability(
      session?.roleCode,
      AppCapability.manageSyncSettings,
    );

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Синхронизация и экспорт',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _tokenController,
                  decoration: const InputDecoration(
                    labelText: 'Токен Яндекс.Диска',
                  ),
                  obscureText: true,
                  enabled: canEdit,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                  FilledButton(
                    onPressed: canEdit ? _saveToken : null,
                    child: const Text('Сохранить токен'),
                  ),
                  OutlinedButton(
                      onPressed: canEdit && !_isPublishing
                          ? () => _publishReferencePackage(actorUserId)
                          : null,
                      child: Text(
                        _isPublishing
                            ? 'Публикация...'
                            : 'Опубликовать пакет справочников',
                      ),
                    ),
                    OutlinedButton(
                      onPressed: canEdit && !_isSyncing
                          ? () => _runSync(actorUserId)
                          : null,
                      child: Text(
                        _isSyncing ? 'Синхронизация...' : 'Запустить синхронизацию',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        syncDiagnosticsAsync.when(
          data: (diagnostics) => Card(
            child: ListTile(
              title: const Text('Диагностика синхронизации'),
              subtitle: Text(
                'Последний пакет справочников: ${diagnostics.lastReferencePackageId ?? 'н/д'}\n'
                'Последняя попытка: ${diagnostics.lastSyncAttemptAt ?? 'н/д'}\n'
                'Последний повтор: ${diagnostics.lastRetryAt ?? 'н/д'}\n'
                'Последний успех: ${diagnostics.lastSuccessAt ?? 'н/д'}\n'
                'Последний конфликт: ${diagnostics.lastConflictAt ?? 'н/д'}\n'
                'Последняя ошибка: ${diagnostics.lastError ?? 'н/д'}\n'
                'Токен настроен: ${diagnostics.transportConfigured ? 'да' : 'нет'}\n'
                'Подключение: ${diagnostics.yandexDiskConnected ? 'да' : 'нет'}\n'
                'Ожидает отправки: ${diagnostics.pendingOutgoingCount}\n'
                'Ожидает получения: ${diagnostics.pendingIncomingCount}\n'
                'Ошибок: ${diagnostics.failedQueueCount}\n'
                'Доступно для повтора: ${diagnostics.retryEligibleCount}\n'
                'Конфликтов: ${diagnostics.conflictCount}',
              ),
              isThreeLine: true,
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Text('Не удалось загрузить диагностику синхронизации: $error'),
        ),
        const SizedBox(height: 16),
        deviceAsync.when(
          data: (device) => Card(
            child: ListTile(
              title: const Text('Информация об устройстве'),
              subtitle: Text(
                device == null
                    ? 'Недоступно'
                    : 'ID: ${device.id}\nПлатформа: ${device.platform}\nКорень: ${device.rootPath}',
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Text('Не удалось загрузить информацию об устройстве: $error'),
        ),
        const SizedBox(height: 16),
        Text(
          'Последние проблемы синхронизации',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        auditEntriesAsync.when(
          data: (entries) {
            final issueEntries = entries
                .where(
                  (entry) =>
                      entry.entry.actionType.startsWith('sync.') &&
                      (entry.entry.resultStatus == 'error' ||
                          entry.entry.resultStatus == 'conflict' ||
                          entry.entry.resultStatus == 'partial'),
                )
                .take(5)
                .toList(growable: false);
            if (issueEntries.isEmpty) {
              return const Text('Недавних конфликтов или ошибок синхронизации нет.');
            }
            return Column(
              children: [
                for (final entry in issueEntries)
                  Card(
                    child: ListTile(
                      title: Text(entry.entry.actionType),
                      subtitle: Text(
                        '${entry.entry.happenedAt}\n${entry.entry.message ?? 'Без подробностей'}',
                      ),
                      isThreeLine: true,
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Text('Не удалось загрузить проблемы синхронизации: $error'),
        ),
        const SizedBox(height: 16),
        Text(
          'Локальная очередь синхронизации',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        queueAsync.when(
          data: (queue) => queue.isEmpty
              ? const Text('Очередь пуста.')
              : Column(
                  children: [
                    for (final entry in queue)
                      Card(
                        child: ListTile(
                          title: Text('${entry.packageType} | ${entry.packageId}'),
                          subtitle: Text(
                            '${entry.status}\n'
                            'Попыток: ${entry.attemptCount}\n'
                            'Следующий повтор: ${entry.nextAttemptAt ?? 'н/д'}\n'
                            '${entry.localPath}'
                            '${entry.lastError == null ? '' : '\n${entry.lastError}'}',
                          ),
                          isThreeLine: true,
                        ),
                      ),
                  ],
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('Не удалось загрузить очередь: $error'),
        ),
      ],
    );
  }

  Future<void> _saveToken() async {
    final value = _tokenController.text.trim();
    if (value.isEmpty) {
      await ref.read(secureSettingsStoreProvider).deleteYandexDiskToken();
    } else {
      await ref.read(secureSettingsStoreProvider).writeYandexDiskToken(value);
    }
    ref.invalidate(syncDiagnosticsProvider);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Токен сохранен в защищенном хранилище.')),
    );
  }

  Future<void> _publishReferencePackage(String? actorUserId) async {
    setState(() => _isPublishing = true);
    try {
      final result = await ref.read(syncServiceProvider).publishReferencePackage(
            actorUserId: actorUserId,
          );
      ref.invalidate(syncQueueEntriesProvider);
      ref.invalidate(auditEntriesProvider);
      ref.invalidate(syncDiagnosticsProvider);
      ref.invalidate(deviceInfoProvider);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Пакет ${result.packageId} опубликован из ${result.exportDirectory.path}',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isPublishing = false);
      }
    }
  }

  Future<void> _runSync(String? actorUserId) async {
    setState(() => _isSyncing = true);
    try {
      final report = await ref.read(syncServiceProvider).runManualSync(
            platform: AppPlatform.windows,
            actorUserId: actorUserId,
          );
      ref.invalidate(syncQueueEntriesProvider);
      ref.invalidate(auditEntriesProvider);
      ref.invalidate(syncDiagnosticsProvider);
      ref.invalidate(deviceInfoProvider);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(report.summaryLabel())),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }
}
