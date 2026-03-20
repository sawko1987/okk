import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_permissions.dart';
import '../../../data/sqlite/app_database.dart';
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
          final usersByRole = <String, List<ManagedUser>>{};
          for (final user in users) {
            counts.update(user.role.id, (value) => value + 1, ifAbsent: () => 1);
            usersByRole.putIfAbsent(user.role.id, () => []).add(user);
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Роли',
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
                        'Фиксированная ролевая модель',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'В версии 1 используется фиксированная матрица прав в коде. Администратор назначает роли пользователям, но не редактирует набор возможностей через интерфейс.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (final role in roles)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _RoleCard(
                      role: role,
                      userCount: counts[role.id] ?? 0,
                      assignedUsers: usersByRole[role.id] ?? const [],
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Не удалось загрузить пользователей: $error')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Не удалось загрузить роли: $error')),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.userCount,
    required this.assignedUsers,
  });

  final Role role;
  final int userCount;
  final List<ManagedUser> assignedUsers;

  @override
  Widget build(BuildContext context) {
    final capabilities = capabilitiesForRole(role.code);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role.name, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(role.description ?? role.code),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Chip(label: Text('Пользователей: $userCount')),
          ],
        ),
        const SizedBox(height: 16),
        Text('Возможности', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (capabilities.isEmpty)
          const Text('Для этой роли возможности не назначены.')
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final capability in capabilities)
                Tooltip(
                  message: capabilityDescription(capability),
                  child: Chip(
                    label: Text(capabilityLabel(capability)),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 16),
        Text('Назначенные пользователи', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (assignedUsers.isEmpty)
          const Text('Пользователи для этой роли пока не назначены.')
        else
          Column(
            children: [
              for (final managedUser in assignedUsers)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.person_outline),
                  title: Text(managedUser.user.fullName),
                  subtitle: Text(
                    managedUser.user.isActive
                        ? 'Активный пользователь'
                        : 'Неактивный пользователь',
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
