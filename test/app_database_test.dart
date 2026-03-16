import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/core/config/app_constants.dart';
import 'package:okk_qc_app/data/sqlite/app_database.dart';

void main() {
  test('seeds baseline roles and device info', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.ensureBootstrapData(
      deviceId: AppConstants.defaultDeviceId,
      deviceName: 'test-host',
      platform: Platform.operatingSystem,
      appVersion: AppConstants.appVersion,
      rootPath: 'D:/OKK/test-data',
    );

    final roles = await database.select(database.roles).get();
    final deviceInfo = await database.select(database.deviceInfo).getSingle();

    expect(roles, hasLength(4));
    expect(deviceInfo.id, AppConstants.defaultDeviceId);
    expect(deviceInfo.syncSchemaVersion, AppConstants.syncSchemaVersion);
  });
}
