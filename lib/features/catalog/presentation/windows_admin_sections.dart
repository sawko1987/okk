import 'package:flutter/material.dart';

enum WindowsAdminSection {
  dashboard,
  structure,
  objects,
  components,
  checklists,
  inspections,
  users,
  roles,
  audit,
  trash,
  backup,
  sync,
}

const windowsAdminSections = <WindowsAdminSection>[
  WindowsAdminSection.dashboard,
  WindowsAdminSection.structure,
  WindowsAdminSection.objects,
  WindowsAdminSection.components,
  WindowsAdminSection.checklists,
  WindowsAdminSection.inspections,
  WindowsAdminSection.users,
  WindowsAdminSection.roles,
  WindowsAdminSection.audit,
  WindowsAdminSection.trash,
  WindowsAdminSection.backup,
  WindowsAdminSection.sync,
];

extension WindowsAdminSectionX on WindowsAdminSection {
  String get pathSegment => switch (this) {
    WindowsAdminSection.dashboard => '',
    WindowsAdminSection.structure => 'structure',
    WindowsAdminSection.objects => 'objects',
    WindowsAdminSection.components => 'components',
    WindowsAdminSection.checklists => 'checklists',
    WindowsAdminSection.inspections => 'inspections',
    WindowsAdminSection.users => 'users',
    WindowsAdminSection.roles => 'roles',
    WindowsAdminSection.audit => 'audit',
    WindowsAdminSection.trash => 'trash',
    WindowsAdminSection.backup => 'backup',
    WindowsAdminSection.sync => 'sync',
  };

  String get label => switch (this) {
    WindowsAdminSection.dashboard => 'Сводка',
    WindowsAdminSection.structure => 'Структура',
    WindowsAdminSection.objects => 'Объекты',
    WindowsAdminSection.components => 'Компоненты',
    WindowsAdminSection.checklists => 'Чек-листы',
    WindowsAdminSection.inspections => 'Проверки',
    WindowsAdminSection.users => 'Пользователи',
    WindowsAdminSection.roles => 'Роли',
    WindowsAdminSection.audit => 'Журнал',
    WindowsAdminSection.trash => 'Корзина',
    WindowsAdminSection.backup => 'Резервные копии',
    WindowsAdminSection.sync => 'Синхронизация',
  };

  IconData get icon => switch (this) {
    WindowsAdminSection.dashboard => Icons.dashboard_outlined,
    WindowsAdminSection.structure => Icons.account_tree_outlined,
    WindowsAdminSection.objects => Icons.device_hub_outlined,
    WindowsAdminSection.components => Icons.memory_outlined,
    WindowsAdminSection.checklists => Icons.checklist_outlined,
    WindowsAdminSection.inspections => Icons.assignment_turned_in_outlined,
    WindowsAdminSection.users => Icons.people_outline,
    WindowsAdminSection.roles => Icons.badge_outlined,
    WindowsAdminSection.audit => Icons.history_outlined,
    WindowsAdminSection.trash => Icons.delete_sweep_outlined,
    WindowsAdminSection.backup => Icons.archive_outlined,
    WindowsAdminSection.sync => Icons.sync_outlined,
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
