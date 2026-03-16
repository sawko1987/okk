import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/storage/app_paths_provider.dart';
import '../../../ui/section_card.dart';

class AndroidInspectionShell extends ConsumerWidget {
  const AndroidInspectionShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paths = ref.watch(appPathsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Android inspection shell'),
        actions: [
          IconButton(
            onPressed: () => context.go('/diagnostics'),
            icon: const Icon(Icons.monitor_heart_outlined),
          ),
          IconButton(
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'Проверка',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_outlined),
            label: 'Синхр.',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'История',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Каркас мобильного потока',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const SectionCard(
            title: 'Будущие экраны',
            lines: [
              'Выбор пользователя / режима',
              'Выбор изделия и объекта',
              'Компоненты / подпись / PDF',
            ],
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Offline storage',
            lines: [paths.signaturesDir.path, paths.reportsDir.path],
          ),
        ],
      ),
    );
  }
}
