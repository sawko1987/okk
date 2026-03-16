import 'dart:io';

import 'package:path/path.dart' as p;

import '../../core/config/app_constants.dart';
import '../../core/logging/app_logger.dart';
import '../../data/sqlite/app_database.dart';
import '../../data/storage/local_storage_service.dart';
import 'bootstrap_data.dart';

Future<BootstrapData> bootstrapApplication() async {
  final storageService = LocalStorageService();
  final paths = await storageService.prepare();

  final logger = AppLogger();
  await logger.initialize(paths.logFile);
  logger.info('Application bootstrap started');

  final database = AppDatabase.connect(paths.databaseFile);
  await database.ensureBootstrapData(
    deviceId: AppConstants.defaultDeviceId,
    deviceName: Platform.localHostname,
    platform: Platform.operatingSystem,
    appVersion: AppConstants.appVersion,
    rootPath: p.normalize(paths.rootDir.path),
  );

  logger.info('Application bootstrap completed');

  return BootstrapData(paths: paths, logger: logger, database: database);
}
