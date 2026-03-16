import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/storage/app_paths.dart';
import '../../data/sqlite/app_database.dart';

class BootstrapData {
  const BootstrapData({
    required this.paths,
    required this.logger,
    required this.database,
  });

  final AppPaths paths;
  final AppLogger logger;
  final AppDatabase database;
}

final bootstrapDataProvider = Provider<BootstrapData>(
  (ref) => throw UnimplementedError('Bootstrap data has not been initialized.'),
);
