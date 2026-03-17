import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/admin_repositories.dart';

class RolesAdminScreen extends ConsumerWidget {
  const RolesAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(rolesProvider);
    final usersAsync = ref.watch(usersProvider);

    return rolesAsync.when(
      data: (roles) => usersAsync.when(
        data: (users) {
          final counts = <String, int>{};
          for (final user in users) {
            counts.update(user.role.id, (value) => value + 1, ifAbsent: () => 1);
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Roles',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              for (final role in roles)
                Card(
                  child: ListTile(
                    title: Text(role.name),
                    subtitle: Text(role.description ?? role.code),
                    trailing: Text('${counts[role.id] ?? 0} users'),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load users: $error')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load roles: $error')),
    );
  }
}
