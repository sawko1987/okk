import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/admin_repositories.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(auditEntriesProvider);

    return entriesAsync.when(
      data: (entries) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Audit log',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            const Text('No audit entries yet.')
          else
            for (final entry in entries)
              Card(
                child: ListTile(
                  title: Text(entry.entry.actionType),
                  subtitle: Text(
                    '${entry.entry.happenedAt}\n'
                    'entity: ${entry.entry.entityType ?? '-'} ${entry.entry.entityId ?? '-'}\n'
                    'user: ${entry.userName ?? '-'}\n'
                    'message: ${entry.entry.message ?? '-'}',
                  ),
                  isThreeLine: true,
                  trailing: Text(entry.entry.resultStatus),
                ),
              ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load audit log: $error')),
    );
  }
}
