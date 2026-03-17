import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../../core/config/app_constants.dart';
import 'tables/app_settings.dart';
import 'tables/component_images.dart';
import 'tables/device_info.dart';
import 'tables/inspection_files.dart';
import 'tables/inspection_signatures.dart';
import 'tables/locks.dart';
import 'tables/roles.dart';
import 'tables/sync_queue.dart';
import 'tables/sync_state.dart';
import 'tables/users.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Roles,
    AppSettings,
    DeviceInfo,
    Users,
    SyncState,
    SyncQueue,
    Locks,
    ComponentImages,
    InspectionSignatures,
    InspectionFiles,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  factory AppDatabase.connect(File databaseFile) {
    return AppDatabase(
      LazyDatabase(() async {
        await databaseFile.parent.create(recursive: true);
        return NativeDatabase(databaseFile);
      }),
    );
  }

  factory AppDatabase.forTesting(QueryExecutor executor) {
    return AppDatabase(executor);
  }

  @override
  int get schemaVersion => AppConstants.appSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(users);
        await migrator.createTable(syncState);
        await migrator.createTable(syncQueue);
        await migrator.createTable(locks);
        await migrator.createTable(componentImages);
        await migrator.createTable(inspectionSignatures);
        await migrator.createTable(inspectionFiles);
      }
    },
  );

  Future<void> ensureBootstrapData({
    required String deviceId,
    required String deviceName,
    required String platform,
    required String appVersion,
    required String rootPath,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();

    await batch((batch) {
      batch.insertAll(roles, [
        RolesCompanion.insert(
          id: 'role-administrator',
          code: 'administrator',
          name: 'Администратор',
          description: const Value(
            'Полный доступ к справочникам и диагностике.',
          ),
          createdAt: now,
          updatedAt: now,
        ),
        RolesCompanion.insert(
          id: 'role-worker',
          code: 'worker',
          name: 'Работник',
          description: const Value(
            'Прохождение проверки и локальное сохранение.',
          ),
          createdAt: now,
          updatedAt: now,
        ),
        RolesCompanion.insert(
          id: 'role-commission',
          code: 'commission',
          name: 'Комиссия',
          description: const Value('Участие в проверке и подпись результата.'),
          createdAt: now,
          updatedAt: now,
        ),
        RolesCompanion.insert(
          id: 'role-viewer',
          code: 'viewer',
          name: 'Просмотр',
          description: const Value('Только чтение доступных данных.'),
          createdAt: now,
          updatedAt: now,
        ),
      ], mode: InsertMode.insertOrIgnore);
    });

    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(
        key: 'sync_schema_version',
        valueJson: AppConstants.syncSchemaVersion,
        updatedAt: now,
      ),
    );

    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(
        key: 'app_name',
        valueJson: AppConstants.appName,
        updatedAt: now,
      ),
    );

    await into(deviceInfo).insertOnConflictUpdate(
      DeviceInfoCompanion.insert(
        id: deviceId,
        deviceName: deviceName,
        platform: platform,
        appVersion: appVersion,
        dbSchemaVersion: schemaVersion.toString(),
        syncSchemaVersion: AppConstants.syncSchemaVersion,
        rootPath: rootPath,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await into(syncState).insertOnConflictUpdate(
      SyncStateCompanion.insert(
        id: '$deviceId-sync-state',
        deviceId: deviceId,
        schemaVersion: AppConstants.syncSchemaVersion,
        updatedAt: now,
      ),
    );
  }
}
