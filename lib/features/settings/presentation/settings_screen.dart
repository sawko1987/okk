import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_permissions.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/platform/app_platform.dart';
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
        title: const Text('Settings'),
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
                title: Text('Android device settings'),
                subtitle: Text(
                  'Use this screen to confirm local storage paths and manage Yandex Disk access for the current device.',
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _SettingsCard(
            title: 'Application',
            children: [
              _SettingsRow(label: 'Application', value: AppConstants.appName),
              _SettingsRow(
                label: 'Database schema version',
                value: '${AppConstants.appSchemaVersion}',
              ),
              _SettingsRow(
                label: 'Sync schema version',
                value: AppConstants.syncSchemaVersion,
              ),
              _SettingsRow(label: 'Storage root', value: paths.rootDir.path),
              _SettingsRow(label: 'Database file', value: paths.databaseFile.path),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: 'Yandex Disk',
            children: [
              if (!canEditSyncSettings)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Sync settings can be changed only by an administrator.',
                  ),
                ),
              TextField(
                controller: _tokenController,
                decoration: const InputDecoration(
                  labelText: 'OAuth token',
                  hintText: 'Paste Yandex Disk token',
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
                    child: Text(_isSaving ? 'Saving...' : 'Save token'),
                  ),
                  OutlinedButton(
                    onPressed: canEditSyncSettings && !_isSaving && !_isClearing
                        ? _clearToken
                        : null,
                    child: Text(_isClearing ? 'Clearing...' : 'Clear token'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              syncDiagnostics.when(
                data: (diagnostics) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SettingsRow(
                      label: 'Token configured',
                      value: diagnostics.transportConfigured ? 'yes' : 'no',
                    ),
                    _SettingsRow(
                      label: 'Remote connectivity',
                      value: diagnostics.yandexDiskConnected ? 'connected' : 'unknown/error',
                    ),
                    _SettingsRow(
                      label: 'Last sync attempt',
                      value: diagnostics.lastSyncAttemptAt ?? 'not available',
                    ),
                    _SettingsRow(
                      label: 'Last sync success',
                      value: diagnostics.lastSuccessAt ?? 'not available',
                    ),
                    _SettingsRow(
                      label: 'Last retry run',
                      value: diagnostics.lastRetryAt ?? 'not available',
                    ),
                    _SettingsRow(
                      label: 'Retry-eligible queue entries',
                      value: '${diagnostics.retryEligibleCount}',
                    ),
                    _SettingsRow(
                      label: 'Last sync error',
                      value: diagnostics.lastError ?? 'not available',
                    ),
                  ],
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(),
                ),
                error: (error, _) => Text('Failed to load sync settings: $error'),
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
        const SnackBar(content: Text('Token stored in secure settings.')),
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
        const SnackBar(content: Text('Token removed from secure settings.')),
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
