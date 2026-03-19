class AndroidRoutes {
  const AndroidRoutes._();

  static const home = '/android';
  static const sync = '/android/sync';
  static const workshops = '/android/workshops';
  static const drafts = '/android/drafts';
  static const results = '/android/results';
  static const settings = '/android/settings';
  static const diagnostics = '/android/diagnostics';

  static String products(String workshopId) =>
      '/android/workshops/$workshopId/products';

  static String targets({
    required String workshopId,
    required String productId,
  }) => '/android/workshops/$workshopId/products/$productId/targets';

  static String components({
    required String workshopId,
    required String productId,
    required String targetId,
  }) =>
      '/android/workshops/$workshopId/products/$productId/targets/$targetId/components';

  static String component({
    required String workshopId,
    required String productId,
    required String targetId,
    required String componentId,
  }) =>
      '/android/workshops/$workshopId/products/$productId/targets/$targetId/components/$componentId';

  static String inspection(String inspectionId) =>
      '/android/inspections/$inspectionId';
}
