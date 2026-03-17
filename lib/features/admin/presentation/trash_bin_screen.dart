import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_service.dart';
import '../../catalog/data/master_data_repositories.dart';
import '../data/admin_repositories.dart';

class TrashBinScreen extends ConsumerWidget {
  const TrashBinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(trashEntriesProvider);
    final canEdit = ref.watch(isAdministratorProvider);
    final actorUserId = ref.watch(activeSessionProvider).valueOrNull?.userId;

    return entriesAsync.when(
      data: (entries) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Trash',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            const Text('Trash is empty.')
          else
            for (final entry in entries)
              Card(
                child: ListTile(
                  title: Text(entry.entry.displayName),
                  subtitle: Text(
                    '${entry.entry.entityType} • deleted ${entry.entry.deletedAt}\n'
                    'by ${entry.deletedByUserName ?? '-'}',
                  ),
                  trailing: OutlinedButton(
                    onPressed: canEdit
                        ? () => _restoreEntry(
                              context,
                              ref,
                              entry.entry.id,
                              actorUserId,
                            )
                        : null,
                    child: const Text('Restore'),
                  ),
                ),
              ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load trash: $error')),
    );
  }

  Future<void> _restoreEntry(
    BuildContext context,
    WidgetRef ref,
    String trashId,
    String? actorUserId,
  ) async {
    try {
      await ref.read(trashRepositoryProvider).restoreEntry(
            trashId,
            actorUserId: actorUserId,
          );
      ref.invalidate(trashEntriesProvider);
      ref.invalidate(auditEntriesProvider);
      ref.invalidate(structureTreeProvider);
      ref.invalidate(objectsViewDataProvider);
      ref.invalidate(componentsScreenDataProvider);
      ref.invalidate(checklistsProvider);
      ref.invalidate(usersProvider);
      refreshAuthProviders(ref);
    } on StateError catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }
}
