import 'package:flutter/material.dart';

enum WindowsAdminSection {
  dashboard,
  structure,
  objects,
  components,
  checklists,
}

const windowsAdminSections = <WindowsAdminSection>[
  WindowsAdminSection.dashboard,
  WindowsAdminSection.structure,
  WindowsAdminSection.objects,
  WindowsAdminSection.components,
  WindowsAdminSection.checklists,
];

extension WindowsAdminSectionX on WindowsAdminSection {
  String get pathSegment => switch (this) {
        WindowsAdminSection.dashboard => '',
        WindowsAdminSection.structure => 'structure',
        WindowsAdminSection.objects => 'objects',
        WindowsAdminSection.components => 'components',
        WindowsAdminSection.checklists => 'checklists',
      };

  String get label => switch (this) {
        WindowsAdminSection.dashboard => 'Главная',
        WindowsAdminSection.structure => 'Структура',
        WindowsAdminSection.objects => 'Объекты',
        WindowsAdminSection.components => 'Компоненты',
        WindowsAdminSection.checklists => 'Чек-листы',
      };

  IconData get icon => switch (this) {
        WindowsAdminSection.dashboard => Icons.dashboard_outlined,
        WindowsAdminSection.structure => Icons.account_tree_outlined,
        WindowsAdminSection.objects => Icons.device_hub_outlined,
        WindowsAdminSection.components => Icons.memory_outlined,
        WindowsAdminSection.checklists => Icons.checklist_outlined,
      };

  String get routePath => this == WindowsAdminSection.dashboard
      ? '/windows'
      : '/windows/$pathSegment';
}

WindowsAdminSection sectionFromPath(String? pathSegment) {
  return windowsAdminSections.firstWhere(
    (section) => section.pathSegment == (pathSegment ?? ''),
    orElse: () => WindowsAdminSection.dashboard,
  );
}
