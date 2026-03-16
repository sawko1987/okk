import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/bootstrap/bootstrap_data.dart';
import 'app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => ref.watch(bootstrapDataProvider).database,
);
