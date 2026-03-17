import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final actorUserId = ref.watch(activeSessionProvider).valueOrNull?.userId;
    final canEdit = ref.watch(isAdministratorProvider);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Sync and export',
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
                    labelText: 'Yandex Disk token',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton(
                      onPressed: canEdit ? _saveToken : null,
                      child: const Text('Save token'),
                    ),
                    OutlinedButton(
                      onPressed: canEdit
                          ? () => _exportReferencePackage(actorUserId)
                          : null,
                      child: const Text('Export reference package'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        deviceAsync.when(
          data: (device) => Card(
            child: ListTile(
              title: const Text('Device info'),
              subtitle: Text(
                device == null
                    ? 'Not available'
                    : 'id: ${device.id}\nplatform: ${device.platform}\nroot: ${device.rootPath}',
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('Failed to load device info: $error'),
        ),
        const SizedBox(height: 16),
        Text(
          'Local sync queue',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        queueAsync.when(
          data: (queue) => queue.isEmpty
              ? const Text('Queue is empty.')
              : Column(
                  children: [
                    for (final entry in queue)
                      Card(
                        child: ListTile(
                          title: Text('${entry.packageType} • ${entry.packageId}'),
                          subtitle: Text('${entry.status}\n${entry.localPath}'),
                          isThreeLine: true,
                        ),
                      ),
                  ],
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('Failed to load queue: $error'),
        ),
      ],
    );
  }

  Future<void> _saveToken() async {
    await ref
        .read(secureSettingsStoreProvider)
        .writeYandexDiskToken(_tokenController.text.trim());
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Token stored in secure settings.')),
    );
  }

  Future<void> _exportReferencePackage(String? actorUserId) async {
    final result = await ref.read(referencePackageRepositoryProvider).exportPackage(
          actorUserId: actorUserId,
        );
    ref.invalidate(syncQueueEntriesProvider);
    ref.invalidate(auditEntriesProvider);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Exported ${result.packageId} to ${result.exportDirectory.path}',
        ),
      ),
    );
  }
}
