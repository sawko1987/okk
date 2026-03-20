enum AppCapability {
  manageCatalog,
  manageUsers,
  manageTrash,
  manageSync,
  manageSyncSettings,
  runSync,
  viewAudit,
  startInspection,
  completeInspection,
  signInspection,
  viewResults,
}

List<AppCapability> capabilitiesForRole(String? roleCode) {
  switch (roleCode) {
    case 'administrator':
      return AppCapability.values;
    case 'worker':
      return const [
        AppCapability.runSync,
        AppCapability.startInspection,
        AppCapability.completeInspection,
        AppCapability.viewResults,
      ];
    case 'commission':
      return const [
        AppCapability.runSync,
        AppCapability.startInspection,
        AppCapability.completeInspection,
        AppCapability.signInspection,
        AppCapability.viewResults,
      ];
    case 'viewer':
      return const [
        AppCapability.runSync,
        AppCapability.viewResults,
      ];
    default:
      return const [];
  }
}

bool roleHasCapability(String? roleCode, AppCapability capability) {
  return capabilitiesForRole(roleCode).contains(capability);
}

String capabilityLabel(AppCapability capability) {
  return switch (capability) {
    AppCapability.manageCatalog => 'Управление справочниками',
    AppCapability.manageUsers => 'Управление пользователями',
    AppCapability.manageTrash => 'Управление корзиной',
    AppCapability.manageSync => 'Синхронизация Windows',
    AppCapability.manageSyncSettings => 'Настройки синхронизации',
    AppCapability.runSync => 'Синхронизация устройства',
    AppCapability.viewAudit => 'Просмотр журнала',
    AppCapability.startInspection => 'Запуск проверок',
    AppCapability.completeInspection => 'Завершение проверок',
    AppCapability.signInspection => 'Подписание проверок',
    AppCapability.viewResults => 'Просмотр результатов',
  };
}

String capabilityDescription(AppCapability capability) {
  return switch (capability) {
    AppCapability.manageCatalog =>
      'Редактирование структуры предприятия, объектов, компонентов и чек-листов.',
    AppCapability.manageUsers =>
      'Создание пользователей, назначение ролей и отключение доступа.',
    AppCapability.manageTrash =>
      'Просмотр и восстановление удаленных записей из корзины.',
    AppCapability.manageSync =>
      'Публикация и импорт пакетов синхронизации из Windows-приложения.',
    AppCapability.manageSyncSettings =>
      'Настройка токена Яндекс.Диска и параметров диагностики синхронизации.',
    AppCapability.runSync =>
      'Запуск ручной синхронизации с текущего устройства.',
    AppCapability.viewAudit =>
      'Просмотр журнала действий и последних эксплуатационных событий.',
    AppCapability.startInspection =>
      'Создание новых проверок и продолжение черновиков на Android.',
    AppCapability.completeInspection =>
      'Завершение проверок, генерация PDF и постановка результатов в очередь.',
    AppCapability.signInspection =>
      'Добавление подписей комиссии при завершении проверки.',
    AppCapability.viewResults =>
      'Просмотр завершенных, ожидающих, синхронизированных и конфликтных результатов.',
  };
}
