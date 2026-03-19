import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/core/config/app_constants.dart';
import 'package:okk_qc_app/data/sqlite/app_database.dart';

void main() {
  test('seeds baseline roles, device info, and sync state', () async {
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
    final syncState = await database.select(database.syncState).getSingle();

    expect(roles, hasLength(4));
    expect(deviceInfo.id, AppConstants.defaultDeviceId);
    expect(deviceInfo.syncSchemaVersion, AppConstants.syncSchemaVersion);
    expect(syncState.deviceId, AppConstants.defaultDeviceId);
    expect(syncState.schemaVersion, AppConstants.syncSchemaVersion);
  });

  test('migrates schema version 1 databases to version 5', () async {
    final executor = NativeDatabase.memory(
      setup: (rawDb) {
        rawDb.execute('''
          CREATE TABLE roles (
            id TEXT NOT NULL PRIMARY KEY,
            code TEXT NOT NULL UNIQUE,
            name TEXT NOT NULL,
            description TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          );
        ''');
        rawDb.execute('''
          CREATE TABLE app_settings (
            key TEXT NOT NULL PRIMARY KEY,
            value_json TEXT NOT NULL,
            updated_at TEXT NOT NULL
          );
        ''');
        rawDb.execute('''
          CREATE TABLE device_info (
            id TEXT NOT NULL PRIMARY KEY,
            device_name TEXT NOT NULL,
            platform TEXT NOT NULL,
            app_version TEXT NOT NULL,
            db_schema_version TEXT NOT NULL,
            sync_schema_version TEXT NOT NULL,
            root_path TEXT NOT NULL,
            last_sync_at TEXT,
            yandex_disk_connected INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          );
        ''');
        rawDb.execute('PRAGMA user_version = 1;');
      },
    );

    final database = AppDatabase.forTesting(executor);
    addTearDown(database.close);

    await database.customSelect('PRAGMA user_version;').getSingle();
    final stateTables = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name IN "
          "('users', 'sync_state', 'sync_queue', 'locks', 'component_images', "
          "'inspection_signatures', 'inspection_files', 'inspections', "
          "'inspection_items', 'departments', "
          "'workshops', 'sections', 'objects', 'object_relations', "
          "'components', 'checklists', 'checklist_items', "
          "'checklist_bindings', 'audit_log', 'trash_bin')",
        )
        .get();

    expect(stateTables, hasLength(20));
    final versionRow =
        await database.customSelect('PRAGMA user_version;').getSingle();
    expect(versionRow.data['user_version'], AppConstants.appSchemaVersion);
  });

  test('stores and updates sync queue records', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    final now = DateTime.now().toUtc().toIso8601String();

    await database.into(database.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: 'queue-1',
            direction: 'outgoing',
            packageType: 'inspection_result',
            packageId: 'pkg-1',
            localPath: 'sync/outgoing/result_pkg-1.zip',
            status: 'pending',
            createdAt: now,
            updatedAt: now,
          ),
        );

    await database.update(database.syncQueue).replace(
          SyncQueueData(
            id: 'queue-1',
            direction: 'outgoing',
            packageType: 'inspection_result',
            packageId: 'pkg-1',
            localPath: 'sync/outgoing/result_pkg-1.zip',
            status: 'failed',
            attemptCount: 1,
            nextAttemptAt: now,
            lastError: 'network timeout',
            createdAt: now,
            updatedAt: now,
          ),
        );

    final queueRecord = await (database.select(database.syncQueue)
          ..where((tbl) => tbl.id.equals('queue-1')))
        .getSingle();

    expect(queueRecord.status, 'failed');
    expect(queueRecord.attemptCount, 1);
    expect(queueRecord.lastError, 'network timeout');
  });
}
