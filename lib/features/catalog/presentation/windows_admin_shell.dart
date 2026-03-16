import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/sqlite/database_provider.dart';
import '../../../data/storage/app_paths_provider.dart';
import '../../../ui/section_card.dart';

class WindowsAdminShell extends ConsumerWidget {
  const WindowsAdminShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paths = ref.watch(appPathsProvider);
    final database = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Windows admin shell'),
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationRail(
              selectedIndex: 0,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  label: Text('Главная'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  label: Text('Справочники'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.sync_outlined),
                  label: Text('Синхронизация'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  label: Text('Журнал'),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Готовность этапа 2',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SectionCard(
                        title: 'SQLite',
                        lines: [
                          'schemaVersion: ${database.schemaVersion}',
                          'db: ${paths.databaseFile.path}',
                        ],
                      ),
                      SectionCard(
                        title: 'Хранилище',
                        lines: [
                          paths.componentsDir.path,
                          paths.syncOutgoingDir.path,
                        ],
                      ),
                      const SectionCard(
                        title: 'Shell sections',
                        lines: [
                          'Каталог / объекты / чек-листы',
                          'Синхронизация / журнал / настройки',
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
