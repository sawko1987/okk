import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_permissions.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/platform/app_platform.dart';
import '../../../core/utils/user_message.dart';
import '../../../data/storage/app_paths_provider.dart';
import '../../../data/storage/secure_settings_provider.dart';
import '../../../data/sync/sync_service.dart';
import '../../../ui/android_app_bar_actions.dart';
import '../../auth/data/auth_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _tokenController;
  bool _tokenLoaded = false;
  bool _isSaving = false;
  bool _isClearing = false;

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
      _tokenController.text = token ?? '';
    });
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paths = ref.watch(appPathsProvider);
    final syncDiagnostics = ref.watch(syncDiagnosticsProvider);
    final session = ref.watch(activeSessionProvider).valueOrNull;
    final canEditSyncSettings = roleHasCapability(
      session?.roleCode,
      AppCapability.manageSyncSettings,
    );
    final isAndroid =
        getAppPlatform() == AppPlatform.android && session != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
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
                leading: Icon(Icons.phone_android_outlined),
                title: Text('Настройки устройства Android'),
                subtitle: Text(
                  'На этом экране можно проверить локальные пути хранения и управлять доступом к Яндекс.Диску для текущего устройства.',
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _SettingsCard(
            title: 'Приложение',
            children: [
              _SettingsRow(label: 'Приложение', value: AppConstants.appName),
              _SettingsRow(
                label: 'Версия схемы базы данных',
                value: '${AppConstants.appSchemaVersion}',
              ),
              _SettingsRow(
                label: 'Версия схемы синхронизации',
                value: AppConstants.syncSchemaVersion,
              ),
              _SettingsRow(label: 'Корень хранилища', value: paths.rootDir.path),
              _SettingsRow(label: 'Файл базы данных', value: paths.databaseFile.path),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: 'Яндекс.Диск',
            children: [
              if (!canEditSyncSettings)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Настройки синхронизации может менять только администратор.',
                  ),
                ),
              TextField(
                controller: _tokenController,
                decoration: const InputDecoration(
                  labelText: 'OAuth-токен',
                  hintText: 'Вставьте токен Яндекс.Диска',
                ),
                obscureText: true,
                enabled: canEditSyncSettings && !_isSaving && !_isClearing,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton(
                    onPressed: canEditSyncSettings && !_isSaving && !_isClearing
                        ? _saveToken
                        : null,
                    child: Text(_isSaving ? 'Сохранение...' : 'Сохранить токен'),
                  ),
                  OutlinedButton(
                    onPressed: canEditSyncSettings && !_isSaving && !_isClearing
                        ? _clearToken
                        : null,
                    child: Text(_isClearing ? 'Очистка...' : 'Удалить токен'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              syncDiagnostics.when(
                data: (diagnostics) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SettingsRow(
                      label: 'Токен настроен',
                      value: diagnostics.transportConfigured ? 'Да' : 'Нет',
                    ),
                    _SettingsRow(
                      label: 'Удаленное подключение',
                      value: diagnostics.yandexDiskConnected
                          ? 'Подключено'
                          : 'Неизвестно или ошибка',
                    ),
                    _SettingsRow(
                      label: 'Последняя попытка синхронизации',
                      value: diagnostics.lastSyncAttemptAt ?? 'Недоступно',
                    ),
                    _SettingsRow(
                      label: 'Последняя успешная синхронизация',
                      value: diagnostics.lastSuccessAt ?? 'Недоступно',
                    ),
                    _SettingsRow(
                      label: 'Последний повторный запуск',
                      value: diagnostics.lastRetryAt ?? 'Недоступно',
                    ),
                    _SettingsRow(
                      label: 'Элементы очереди, доступные для повтора',
                      value: '${diagnostics.retryEligibleCount}',
                    ),
                    _SettingsRow(
                      label: 'Последняя ошибка синхронизации',
                      value: diagnostics.lastError ?? 'Недоступно',
                    ),
                  ],
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(),
                ),
                error: (error, _) => Text(
                  'Не удалось загрузить настройки синхронизации. ${userMessageFromError(error, fallback: 'Проверьте локальные настройки и повторите попытку.')}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveToken() async {
    setState(() => _isSaving = true);
    try {
      await ref
          .read(secureSettingsStoreProvider)
          .writeYandexDiskToken(_tokenController.text);
      ref.invalidate(syncDiagnosticsProvider);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Токен сохранен в защищенном хранилище.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userMessageFromError(
              error,
              fallback: 'Не удалось сохранить токен.',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _clearToken() async {
    setState(() => _isClearing = true);
    try {
      await ref.read(secureSettingsStoreProvider).deleteYandexDiskToken();
      _tokenController.clear();
      ref.invalidate(syncDiagnosticsProvider);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Токен удален из защищенного хранилища.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userMessageFromError(
              error,
              fallback: 'Не удалось удалить токен.',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isClearing = false);
      }
    }
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
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
