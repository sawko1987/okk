import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../core/config/app_constants.dart';
import '../../../data/storage/app_paths_provider.dart';
import '../../auth/data/auth_service.dart';
import '../data/backup_repository.dart';

class BackupAdminScreen extends ConsumerStatefulWidget {
  const BackupAdminScreen({super.key});

  @override
  ConsumerState<BackupAdminScreen> createState() => _BackupAdminScreenState();
}

class _BackupAdminScreenState extends ConsumerState<BackupAdminScreen> {
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    final paths = ref.watch(appPathsProvider);
    final backupsAsync = ref.watch(backupsProvider);
    final session = ref.watch(activeSessionProvider).valueOrNull;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Резервные копии',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Создание архива',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _InfoRow(label: 'Каталог резервных копий', value: paths.backupDir.path),
                _InfoRow(
                  label: 'Версия схемы БД',
                  value: '${AppConstants.appSchemaVersion}',
                ),
                _InfoRow(
                  label: 'Версия схемы синхронизации',
                  value: AppConstants.syncSchemaVersion,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Архив включает снимок базы данных, медиафайлы, журналы и очереди синхронизации. '
                  'Каталог backup не попадает внутрь архива.',
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _isCreating
                      ? null
                      : () => _createBackup(actorUserId: session?.userId),
                  icon: _isCreating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.archive_outlined),
                  label: Text(
                    _isCreating
                        ? 'Создание архива...'
                        : 'Создать резервную копию',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => ref.invalidate(backupsProvider),
                  icon: const Icon(Icons.verified_outlined),
                  label: const Text('Обновить проверку архивов'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Готовность к восстановлению',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'В этом этапе доступна проверка архивов и совместимости версий. '
                  'Восстановление выполняется только через staging и завершает работу приложения, '
                  'чтобы после замены app_data следующая загрузка уже открыла восстановленные данные.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Локальные архивы',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        backupsAsync.when(
          data: (backups) {
            if (backups.isEmpty) {
              return const Text(
                'Архивы еще не создавались. После первого создания резервной копии они появятся в этом списке.',
              );
            }

            return Column(
              children: [
                for (final backup in backups) ...[
                  _BackupCard(
                    backup: backup,
                    onRestore: backup.isRestorable
                        ? () => _confirmRestore(
                              backup: backup,
                              actorUserId: session?.userId,
                            )
                        : null,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text(
            'Не удалось загрузить список резервных копий: $error',
          ),
        ),
      ],
    );
  }

  Future<void> _createBackup({required String? actorUserId}) async {
    setState(() => _isCreating = true);
    try {
      final backup = await ref.read(backupRepositoryProvider).createBackup(
            actorUserId: actorUserId,
          );
      ref.invalidate(backupsProvider);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Архив ${backup.archiveName} создан в ${backup.archivePath}',
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
        setState(() => _isCreating = false);
      }
    }
  }

  Future<void> _confirmRestore({
    required BackupArchiveSummary backup,
    required String? actorUserId,
  }) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Подтвердите восстановление'),
            content: Text(
              'Архив ${backup.archiveName} заменит текущие локальные данные в app_data. '
              'Текущий каталог будет сохранен как резервный снимок перед swap. '
              'После завершения приложение закроется для безопасного перезапуска.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Отмена'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Восстановить'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) {
      return;
    }

    try {
      final result = await ref.read(backupRepositoryProvider).restoreBackup(
            archiveFile: File(backup.archivePath),
            actorUserId: actorUserId,
          );
      if (!mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Восстановление завершено'),
          content: Text(
            'Данные восстановлены из архива ${backup.archiveName}.\n\n'
            'Новый рабочий каталог: ${result.restoredRootPath}\n'
            'Предыдущий каталог сохранен в: ${result.previousRootPath}\n\n'
            'Приложение будет закрыто, после чего его нужно запустить снова.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Закрыть приложение'),
            ),
          ],
        ),
      );
      if (Platform.isWindows) {
        exit(0);
      }
      await SystemNavigator.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }
}

class _BackupCard extends StatelessWidget {
  const _BackupCard({
    required this.backup,
    required this.onRestore,
  });

  final BackupArchiveSummary backup;
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    final compatibility = !backup.isInspectable
        ? 'Архив не прошел проверку'
        : backup.isSchemaCompatible
            ? 'Совместим по версиям'
            : 'Требует ручной проверки совместимости';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(backup.archiveName, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _InfoRow(label: 'Статус', value: compatibility),
            if (backup.restoreIssues.isNotEmpty)
              _InfoRow(
                label: 'Причины ограничений',
                value: backup.restoreIssues.join('\n'),
              ),
            _InfoRow(
              label: 'Создан',
              value: backup.createdAt ?? 'Недоступно',
            ),
            _InfoRow(
              label: 'Устройство',
              value: _deviceLabel(backup),
            ),
            _InfoRow(
              label: 'Файлов в архиве',
              value: '${backup.fileCount}',
            ),
            _InfoRow(
              label: 'Размер архива',
              value: _formatBytes(backup.archiveSizeBytes),
            ),
            _InfoRow(
              label: 'Схема БД',
              value: backup.dbSchemaVersion?.toString() ?? 'Недоступно',
            ),
            _InfoRow(
              label: 'Схема синхронизации',
              value: backup.syncSchemaVersion ?? 'Недоступно',
            ),
            _InfoRow(
              label: 'Корневые разделы',
              value: backup.includedRoots.isEmpty
                  ? 'Недоступно'
                  : backup.includedRoots.join(', '),
            ),
            _InfoRow(label: 'Путь к архиву', value: backup.archivePath),
            if (backup.inspectionError != null)
              _InfoRow(
                label: 'Ошибка проверки',
                value: backup.inspectionError!,
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: onRestore,
                icon: const Icon(Icons.restore_outlined),
                label: const Text('Восстановить из архива'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 2),
          SelectableText(value),
        ],
      ),
    );
  }
}

String _formatBytes(int bytes) {
  const units = ['Б', 'КБ', 'МБ', 'ГБ'];
  var value = bytes.toDouble();
  var unitIndex = 0;

  while (value >= 1024 && unitIndex < units.length - 1) {
    value /= 1024;
    unitIndex++;
  }

  final fractionDigits = unitIndex == 0 ? 0 : 1;
  return '${value.toStringAsFixed(fractionDigits)} ${units[unitIndex]}';
}

String _deviceLabel(BackupArchiveSummary backup) {
  final parts = <String>[
    if ((backup.deviceName ?? '').isNotEmpty) backup.deviceName!,
    if ((backup.deviceId ?? '').isNotEmpty) backup.deviceId!,
  ];
  return parts.isEmpty ? 'Недоступно' : parts.join(' / ');
}
