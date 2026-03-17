import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/sqlite/database_provider.dart';
import '../../../data/storage/app_paths_provider.dart';
import 'checklists_admin_screen.dart';
import 'components_admin_screen.dart';
import 'objects_admin_screen.dart';
import 'structure_admin_screen.dart';
import 'windows_admin_sections.dart';
import 'windows_dashboard_screen.dart';

class WindowsAdminShell extends ConsumerWidget {
  const WindowsAdminShell({
    super.key,
    required this.section,
  });

  final WindowsAdminSection section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paths = ref.watch(appPathsProvider);
    final database = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Windows админка: ${section.label}'),
        actions: [
          TextButton(
            onPressed: () => context.go('/diagnostics'),
            child: const Text('Диагностика'),
          ),
          TextButton(
            onPressed: () => context.go('/settings'),
            child: const Text('Настройки'),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
            selectedIndex: windowsAdminSections.indexOf(section),
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
              child: switch (section) {
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
