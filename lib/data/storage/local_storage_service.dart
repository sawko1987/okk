import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/storage/app_paths.dart';

class LocalStorageService {
  Future<AppPaths> prepare() async {
    final supportDir = await getApplicationSupportDirectory();
    final rootDir = Directory(p.join(supportDir.path, 'app_data'));
    final paths = AppPaths(rootDir: rootDir);
    await paths.ensureCreated();
    return paths;
  }
}
