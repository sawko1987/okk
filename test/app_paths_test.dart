import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/core/storage/app_paths.dart';
import 'package:path/path.dart' as p;

void main() {
  test('creates expected local directories', () async {
    final tempDir = await Directory.systemTemp.createTemp('okk_qc_paths_');
    addTearDown(() => tempDir.delete(recursive: true));

    final paths = AppPaths.forTesting(p.join(tempDir.path, 'app_data'));
    await paths.ensureCreated();

    expect(paths.dbDir.existsSync(), isTrue);
    expect(paths.componentsDir.existsSync(), isTrue);
    expect(paths.syncOutgoingDir.existsSync(), isTrue);
    expect(paths.logsDir.existsSync(), isTrue);
    expect(paths.databaseFile.path, endsWith(p.join('db', 'main.db')));
  });
}
