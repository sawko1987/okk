import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okk_qc_app/app/bootstrap/bootstrap_data.dart';
import 'package:okk_qc_app/app/router/app_router.dart';
import 'package:okk_qc_app/core/logging/app_logger.dart';
import 'package:okk_qc_app/core/storage/app_paths.dart';
import 'package:okk_qc_app/data/sqlite/app_database.dart';
import 'package:path/path.dart' as p;

void main() {
  test('creates app router from bootstrap dependencies', () async {
    final tempDir = await Directory.systemTemp.createTemp('okk_qc_app_test_');
    addTearDown(() => tempDir.delete(recursive: true));

    final paths = AppPaths.forTesting(p.join(tempDir.path, 'app_data'));
    await paths.ensureCreated();

    final logger = AppLogger();
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.ensureBootstrapData(
      deviceId: 'test-device',
      deviceName: 'test-host',
      platform: 'windows',
      appVersion: '1.0.0+1',
      rootPath: paths.rootDir.path,
    );
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [
        bootstrapDataProvider.overrideWithValue(
          BootstrapData(paths: paths, logger: logger, database: database),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);

    expect(router.routeInformationProvider.value.uri.path, '/');
  });
}
