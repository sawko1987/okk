import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../../core/config/app_constants.dart';
import 'tables/app_settings.dart';
import 'tables/catalog_objects.dart';
import 'tables/checklist_bindings.dart';
import 'tables/checklist_items.dart';
import 'tables/checklists.dart';
import 'tables/component_images.dart';
import 'tables/components.dart';
import 'tables/departments.dart';
import 'tables/device_info.dart';
import 'tables/inspection_files.dart';
import 'tables/inspection_signatures.dart';
import 'tables/locks.dart';
import 'tables/object_relations.dart';
import 'tables/roles.dart';
import 'tables/sections.dart';
import 'tables/sync_queue.dart';
import 'tables/sync_state.dart';
import 'tables/users.dart';
import 'tables/workshops.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Roles,
    AppSettings,
    DeviceInfo,
    Users,
    Departments,
    Workshops,
    Sections,
    CatalogObjects,
    ObjectRelations,
    Components,
    Checklists,
    ChecklistItems,
    ChecklistBindings,
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
      await _createCustomIndexes();
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

      if (from < 3) {
        await migrator.createTable(departments);
        await migrator.createTable(workshops);
        await migrator.createTable(sections);
        await migrator.createTable(catalogObjects);
        await migrator.createTable(objectRelations);
        await migrator.createTable(components);
        await migrator.createTable(checklists);
        await migrator.createTable(checklistItems);
        await migrator.createTable(checklistBindings);
        await _createCustomIndexes();
      }
    },
  );

  Future<void> _createCustomIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_users_role_id ON users (role_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_users_active ON users (is_active);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_workshops_department_id ON workshops (department_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_sections_workshop_id ON sections (workshop_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_objects_section_id ON objects (section_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_objects_parent_id ON objects (parent_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_objects_type ON objects (type);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_object_relations_parent ON object_relations (parent_object_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_object_relations_child ON object_relations (child_object_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_components_object_id ON components (object_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_component_images_component_id ON component_images (component_id);',
    );
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS ux_component_images_media_key ON component_images (media_key);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_checklist_items_checklist_id ON checklist_items (checklist_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_checklist_items_component_id ON checklist_items (component_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_checklist_bindings_checklist_id ON checklist_bindings (checklist_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_checklist_bindings_target ON checklist_bindings (target_type, target_id, target_object_type);',
    );
  }

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
