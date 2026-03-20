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
    AppCapability.manageCatalog => 'Manage catalog',
    AppCapability.manageUsers => 'Manage users',
    AppCapability.manageTrash => 'Manage trash',
    AppCapability.manageSync => 'Run Windows sync',
    AppCapability.manageSyncSettings => 'Manage sync settings',
    AppCapability.runSync => 'Run device sync',
    AppCapability.viewAudit => 'View audit log',
    AppCapability.startInspection => 'Start inspections',
    AppCapability.completeInspection => 'Complete inspections',
    AppCapability.signInspection => 'Sign inspections',
    AppCapability.viewResults => 'View results',
  };
}

String capabilityDescription(AppCapability capability) {
  return switch (capability) {
    AppCapability.manageCatalog =>
      'Edit enterprise structure, objects, components, and checklists.',
    AppCapability.manageUsers =>
      'Create users, change role assignments, and deactivate access.',
    AppCapability.manageTrash =>
      'Restore or review deleted records in the trash bin.',
    AppCapability.manageSync =>
      'Publish and import sync packages from the Windows admin app.',
    AppCapability.manageSyncSettings =>
      'Configure Yandex Disk token and sync diagnostics settings.',
    AppCapability.runSync =>
      'Start manual synchronization from the current device.',
    AppCapability.viewAudit =>
      'Read audit history and recent operational events.',
    AppCapability.startInspection =>
      'Create or resume inspection drafts from Android.',
    AppCapability.completeInspection =>
      'Finish inspections, generate PDF, and queue results.',
    AppCapability.signInspection =>
      'Add commission signatures during inspection completion.',
    AppCapability.viewResults =>
      'Open completed, queued, synced, or conflict results.',
  };
}
