import 'package:flutter/material.dart';

import '../../../ui/section_card.dart';

class WindowsDashboardScreen extends StatelessWidget {
  const WindowsDashboardScreen({
    super.key,
    required this.databasePath,
    required this.schemaVersion,
    required this.componentsDir,
    required this.syncOutgoingDir,
  });

  final String databasePath;
  final int schemaVersion;
  final String componentsDir;
  final String syncOutgoingDir;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Этап 3A: справочные данные для Windows',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(
          'Подготовка справочников, структуры предприятия, объектов, компонентов и чек-листов.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SectionCard(
              title: 'SQLite',
              lines: [
                'Версия схемы: $schemaVersion',
                'База данных: $databasePath',
              ],
            ),
            SectionCard(
              title: 'Хранилище',
              lines: [componentsDir, syncOutgoingDir],
            ),
            const SectionCard(
              title: 'Рабочие разделы',
              lines: [
                'Структура предприятия',
                'Объекты и иерархия',
                'Компоненты',
                'Чек-листы и привязки',
              ],
            ),
          ],
        ),
      ],
    );
  }
}
