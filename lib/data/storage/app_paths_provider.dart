import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/bootstrap/bootstrap_data.dart';
import '../../core/storage/app_paths.dart';

final appPathsProvider = Provider<AppPaths>(
  (ref) => ref.watch(bootstrapDataProvider).paths,
);
