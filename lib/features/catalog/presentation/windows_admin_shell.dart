import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/platform/app_platform.dart';
import '../../../data/sync/sync_service.dart';
import '../../admin/presentation/audit_log_screen.dart';
import '../../admin/presentation/roles_admin_screen.dart';
import '../../admin/presentation/sync_admin_screen.dart';
import '../../admin/presentation/trash_bin_screen.dart';
import '../../admin/presentation/users_admin_screen.dart';
import '../../auth/data/auth_service.dart';
import '../../../data/sqlite/database_provider.dart';
import '../../../data/storage/app_paths_provider.dart';
import 'checklists_admin_screen.dart';
import 'components_admin_screen.dart';
import 'objects_admin_screen.dart';
import 'structure_admin_screen.dart';
import 'windows_admin_sections.dart';
import 'windows_dashboard_screen.dart';

class WindowsAdminShell extends ConsumerStatefulWidget {
  const WindowsAdminShell({
    super.key,
    required this.section,
  });

  final WindowsAdminSection section;

  @override
  ConsumerState<WindowsAdminShell> createState() => _WindowsAdminShellState();
}

class _WindowsAdminShellState extends ConsumerState<WindowsAdminShell> {
  bool _startupSyncTriggered = false;

  @override
  Widget build(BuildContext context) {
    final paths = ref.watch(appPathsProvider);
    final database = ref.watch(appDatabaseProvider);
    final session = ref.watch(activeSessionProvider).valueOrNull;
    if (!_startupSyncTriggered && session != null) {
      _startupSyncTriggered = true;
      Future<void>.microtask(
        () => ref.read(syncServiceProvider).syncOnStartup(
              platform: AppPlatform.windows,
              actorUserId: session.userId,
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Windows admin: ${widget.section.label}'),
        actions: [
          if (session != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('${session.fullName} (${session.roleName})'),
              ),
            ),
          TextButton(
            onPressed: () => context.go('/diagnostics'),
            child: const Text('Diagnostics'),
          ),
          TextButton(
            onPressed: () => context.go('/settings'),
            child: const Text('Settings'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(authServiceProvider).logout();
              refreshAuthProviders(ref);
              if (!context.mounted) {
                return;
              }
              context.go('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
            selectedIndex: windowsAdminSections.indexOf(widget.section),
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (index) {
              context.go(windowsAdminSections[index].routePath);
            },
            destinations: [
              for (final value in windowsAdminSections)
                NavigationRailDestination(
                  icon: Icon(value.icon),
                  label: Text(value.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: switch (widget.section) {
                WindowsAdminSection.dashboard => WindowsDashboardScreen(
                    key: const ValueKey('dashboard'),
                    databasePath: paths.databaseFile.path,
                    schemaVersion: database.schemaVersion,
                    componentsDir: paths.componentsDir.path,
                    syncOutgoingDir: paths.syncOutgoingDir.path,
                  ),
                WindowsAdminSection.structure =>
                  const StructureAdminScreen(key: ValueKey('structure')),
                WindowsAdminSection.objects =>
                  const ObjectsAdminScreen(key: ValueKey('objects')),
                WindowsAdminSection.components =>
                  const ComponentsAdminScreen(key: ValueKey('components')),
                WindowsAdminSection.checklists =>
                  const ChecklistsAdminScreen(key: ValueKey('checklists')),
                WindowsAdminSection.users =>
                  const UsersAdminScreen(key: ValueKey('users')),
                WindowsAdminSection.roles =>
                  const RolesAdminScreen(key: ValueKey('roles')),
                WindowsAdminSection.audit =>
                  const AuditLogScreen(key: ValueKey('audit')),
                WindowsAdminSection.trash =>
                  const TrashBinScreen(key: ValueKey('trash')),
                WindowsAdminSection.sync =>
                  const SyncAdminScreen(key: ValueKey('sync')),
              },
            ),
          ),
        ],
      ),
    );
  }
}
