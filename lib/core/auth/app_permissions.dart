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

bool roleHasCapability(String? roleCode, AppCapability capability) {
  switch (roleCode) {
    case 'administrator':
      return true;
    case 'worker':
      return switch (capability) {
        AppCapability.runSync ||
        AppCapability.startInspection ||
        AppCapability.completeInspection ||
        AppCapability.viewResults => true,
        _ => false,
      };
    case 'commission':
      return switch (capability) {
        AppCapability.runSync ||
        AppCapability.startInspection ||
        AppCapability.completeInspection ||
        AppCapability.signInspection ||
        AppCapability.viewResults => true,
        _ => false,
      };
    case 'viewer':
      return capability == AppCapability.viewResults ||
          capability == AppCapability.runSync;
    default:
      return false;
  }
}
