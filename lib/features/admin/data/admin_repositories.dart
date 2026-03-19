import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide Component;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../core/auth/app_permissions.dart';
import '../../../core/utils/checksum.dart';
import '../../../core/storage/app_paths.dart';
import '../../../data/sqlite/app_database.dart';
import '../../../data/sqlite/database_provider.dart';
import '../../../data/sqlite/repository_support.dart';
import '../../../data/storage/app_paths_provider.dart';

class ManagedUser {
  const ManagedUser({
    required this.user,
    required this.role,
  });

  final User user;
  final Role role;
}

class AuditEntryView {
  const AuditEntryView({
    required this.entry,
    required this.userName,
  });

  final AuditLogData entry;
  final String? userName;
}

class TrashEntryView {
  const TrashEntryView({
    required this.entry,
    required this.deletedByUserName,
  });

  final TrashBinData entry;
  final String? deletedByUserName;
}

class ReferencePackageResult {
  const ReferencePackageResult({
    required this.packageId,
    required this.exportDirectory,
    required this.queueRecordId,
  });

  final String packageId;
  final Directory exportDirectory;
  final String queueRecordId;
}

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) => UsersRepository(ref.watch(appDatabaseProvider)),
);

final componentImagesRepositoryProvider = Provider<ComponentImagesRepository>(
  (ref) => ComponentImagesRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(appPathsProvider),
  ),
);

final auditRepositoryProvider = Provider<AuditRepository>(
  (ref) => AuditRepository(ref.watch(appDatabaseProvider)),
);

final trashRepositoryProvider = Provider<TrashRepository>(
  (ref) => TrashRepository(ref.watch(appDatabaseProvider)),
);

final referencePackageRepositoryProvider = Provider<ReferencePackageRepository>(
  (ref) => ReferencePackageRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(appPathsProvider),
  ),
);

final usersProvider = FutureProvider<List<ManagedUser>>(
  (ref) => ref.watch(usersRepositoryProvider).listUsers(),
);

final rolesProvider = FutureProvider<List<Role>>(
  (ref) => ref.watch(usersRepositoryProvider).listRoles(),
);

final auditEntriesProvider = FutureProvider<List<AuditEntryView>>(
  (ref) => ref.watch(auditRepositoryProvider).listRecent(),
);

final trashEntriesProvider = FutureProvider<List<TrashEntryView>>(
  (ref) => ref.watch(trashRepositoryProvider).listEntries(),
);

final componentImagesProvider =
    FutureProvider.family<List<ComponentImage>, String>((ref, componentId) {
  return ref.watch(componentImagesRepositoryProvider).listByComponent(componentId);
});

final syncQueueEntriesProvider = FutureProvider<List<SyncQueueData>>(
  (ref) => ref.watch(referencePackageRepositoryProvider).listQueueEntries(),
);

final deviceInfoProvider = FutureProvider<DeviceInfoData?>(
  (ref) => ref.watch(referencePackageRepositoryProvider).loadDeviceInfo(),
);

class UsersRepository {
  UsersRepository(this._db);

  final AppDatabase _db;

  Future<List<ManagedUser>> listUsers() async {
    final users = await (_db.select(_db.users)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.fullName),
          ]))
        .get();
    final roles = await _db.select(_db.roles).get();
    final rolesById = {for (final role in roles) role.id: role};

    return users
        .map(
          (user) => ManagedUser(
            user: user,
            role: rolesById[user.roleId] ??
                Role(
                  id: 'missing',
                  code: 'viewer',
                  name: 'Unknown',
                  description: null,
                  createdAt: '',
                  updatedAt: '',
                ),
          ),
        )
        .toList(growable: false);
  }

  Future<List<Role>> listRoles() {
    return (_db.select(_db.roles)
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
  }

  Future<void> saveUser({
    String? id,
    required String fullName,
    String? shortName,
    required String roleId,
    required bool isActive,
    String? pin,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageUsers,
      deniedMessage: 'Only administrators can manage users.',
    );
    final now = nowIso();
    final cleanedShortName = nullableField(shortName) ?? firstWords(fullName);
    final cleanedPin = nullableField(pin);
    final hashedPin = cleanedPin == null ? null : pinHash(cleanedPin);

    if (id == null) {
      final newId = generateId('user');
      await _db.into(_db.users).insert(
            UsersCompanion.insert(
              id: newId,
              fullName: fullName.trim(),
              shortName: Value(cleanedShortName),
              roleId: roleId,
              pinHash: hashedPin == null ? const Value.absent() : Value(hashedPin),
              isActive: Value(isActive),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await recordAudit(
        _db,
        actionType: 'user.create',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'user',
        entityId: newId,
        message: 'User created',
        payload: {
          'full_name': fullName.trim(),
          'role_id': roleId,
          'is_active': isActive,
        },
      );
      return;
    }

    final existing = await (_db.select(_db.users)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(id))).write(
      UsersCompanion(
        fullName: Value(fullName.trim()),
        shortName: Value(cleanedShortName),
        roleId: Value(roleId),
        pinHash: hashedPin == null ? Value(existing.pinHash) : Value(hashedPin),
        isActive: Value(isActive),
        updatedAt: Value(now),
        version: Value(existing.version + 1),
      ),
    );
    await recordAudit(
      _db,
      actionType: 'user.update',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'user',
      entityId: id,
      message: 'User updated',
      payload: {
        'full_name': fullName.trim(),
        'role_id': roleId,
        'is_active': isActive,
      },
    );
  }

  Future<void> deleteUser(
    String id, {
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageUsers,
      deniedMessage: 'Only administrators can manage users.',
    );
    final existing = await (_db.select(_db.users)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
    final now = nowIso();

    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(id))).write(
      UsersCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
        version: Value(existing.version + 1),
      ),
    );
    await addTrashEntry(
      _db,
      entityType: 'user',
      entityId: id,
      displayName: existing.fullName,
      deletedByUserId: actorUserId,
      deletedAt: now,
      snapshot: {
        'id': existing.id,
        'full_name': existing.fullName,
        'short_name': existing.shortName,
        'role_id': existing.roleId,
      },
    );
    await recordAudit(
      _db,
      actionType: 'user.delete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'user',
      entityId: id,
      message: 'User moved to trash',
    );
  }
}

class ComponentImagesRepository {
  ComponentImagesRepository(this._db, this._paths);

  final AppDatabase _db;
  final AppPaths _paths;

  Future<List<ComponentImage>> listByComponent(String componentId) {
    return (_db.select(_db.componentImages)
          ..where(
            (tbl) =>
                tbl.componentId.equals(componentId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.fileName),
          ]))
        .get();
  }

  Future<void> importImages({
    required String componentId,
    required List<String> sourcePaths,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Only administrators can modify component media.',
    );
    final sanitizedPaths = sourcePaths
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty)
        .toList(growable: false);
    if (sanitizedPaths.isEmpty) {
      return;
    }

    final targetDir = Directory(_paths.resolveRelativePath('media/components/$componentId'));
    await targetDir.create(recursive: true);
    final existing = await listByComponent(componentId);
    var sortOrder = existing.length;

    for (final sourcePath in sanitizedPaths) {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw StateError('Source file does not exist: $sourcePath');
      }

      final fileName = await _nextAvailableFileName(targetDir, p.basename(sourcePath));
      final destinationFile = File(p.join(targetDir.path, fileName));
      await sourceFile.copy(destinationFile.path);

      final checksum = await checksumFile(destinationFile);
      final relativePath = _paths.componentImageRelativePath(componentId, fileName);

      await _db.into(_db.componentImages).insert(
            ComponentImagesCompanion.insert(
              id: generateId('component-image'),
              componentId: componentId,
              fileName: fileName,
              mediaKey: '$componentId/$fileName',
              localPath: Value(relativePath),
              checksum: checksum,
              mimeType: _guessMimeType(fileName),
              sortOrder: Value(sortOrder++),
              createdAt: nowIso(),
              updatedAt: nowIso(),
            ),
          );
    }

    await recordAudit(
      _db,
      actionType: 'component_image.import',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'component',
      entityId: componentId,
      message: 'Component images imported',
      payload: {'count': sanitizedPaths.length},
    );
  }

  Future<void> deleteImage(
    String imageId, {
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Only administrators can modify component media.',
    );
    final existing = await (_db.select(_db.componentImages)
          ..where((tbl) => tbl.id.equals(imageId)))
        .getSingle();
    final now = nowIso();
    await (_db.update(_db.componentImages)
          ..where((tbl) => tbl.id.equals(imageId)))
        .write(
      ComponentImagesCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
        version: Value(existing.version + 1),
      ),
    );
    await addTrashEntry(
      _db,
      entityType: 'component_image',
      entityId: imageId,
      displayName: existing.fileName,
      deletedByUserId: actorUserId,
      deletedAt: now,
      snapshot: {
        'id': existing.id,
        'component_id': existing.componentId,
        'file_name': existing.fileName,
        'local_path': existing.localPath,
      },
    );
    await recordAudit(
      _db,
      actionType: 'component_image.delete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'component_image',
      entityId: imageId,
      message: 'Component image moved to trash',
    );
  }

  Future<String> _nextAvailableFileName(Directory dir, String originalName) async {
    final extension = p.extension(originalName);
    final baseName = p.basenameWithoutExtension(originalName);
    var candidate = originalName;
    var index = 1;

    while (await File(p.join(dir.path, candidate)).exists()) {
      candidate = '${baseName}_$index$extension';
      index++;
    }

    return candidate;
  }

  String _guessMimeType(String fileName) {
    switch (p.extension(fileName).toLowerCase()) {
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.webp':
        return 'image/webp';
      case '.bmp':
        return 'image/bmp';
      default:
        return 'application/octet-stream';
    }
  }
}

class AuditRepository {
  AuditRepository(this._db);

  final AppDatabase _db;

  Future<List<AuditEntryView>> listRecent({int limit = 200}) async {
    final entries = await (_db.select(_db.auditLog)
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.happenedAt),
          ])
          ..limit(limit))
        .get();
    final users = await _db.select(_db.users).get();
    final namesById = {for (final user in users) user.id: user.fullName};

    return entries
        .map(
          (entry) => AuditEntryView(
            entry: entry,
            userName: namesById[entry.userId],
          ),
        )
        .toList(growable: false);
  }
}

class TrashRepository {
  TrashRepository(this._db);

  final AppDatabase _db;

  Future<List<TrashEntryView>> listEntries() async {
    final entries = await (_db.select(_db.trashBin)
          ..where((tbl) => tbl.restoredAt.isNull() & tbl.permanentlyDeletedAt.isNull())
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.deletedAt),
          ]))
        .get();
    final users = await _db.select(_db.users).get();
    final namesById = {for (final user in users) user.id: user.fullName};

    return entries
        .map(
          (entry) => TrashEntryView(
            entry: entry,
            deletedByUserName: namesById[entry.deletedByUserId],
          ),
        )
        .toList(growable: false);
  }

  Future<void> restoreEntry(
    String trashId, {
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageTrash,
      deniedMessage: 'Only administrators can restore items from trash.',
    );
    final trashEntry = await (_db.select(_db.trashBin)
          ..where((tbl) => tbl.id.equals(trashId)))
        .getSingle();
    final now = nowIso();

    await _db.transaction(() async {
      switch (trashEntry.entityType) {
        case 'department':
          await _restoreSoftDeleted(_db.departments, trashEntry.entityId, now);
          break;
        case 'workshop':
          await _restoreSoftDeleted(_db.workshops, trashEntry.entityId, now);
          break;
        case 'section':
          await _restoreSoftDeleted(_db.sections, trashEntry.entityId, now);
          break;
        case 'object':
          await _restoreSoftDeleted(_db.catalogObjects, trashEntry.entityId, now);
          break;
        case 'component':
          await _restoreSoftDeleted(_db.components, trashEntry.entityId, now);
          break;
        case 'component_image':
          await _restoreSoftDeleted(_db.componentImages, trashEntry.entityId, now);
          break;
        case 'checklist':
          await _restoreSoftDeleted(_db.checklists, trashEntry.entityId, now);
          break;
        case 'checklist_item':
          await _restoreSoftDeleted(_db.checklistItems, trashEntry.entityId, now);
          break;
        case 'checklist_binding':
          await _restoreSoftDeleted(_db.checklistBindings, trashEntry.entityId, now);
          break;
        case 'user':
          await _restoreSoftDeleted(_db.users, trashEntry.entityId, now);
          break;
        default:
          throw StateError('Restore is not supported for ${trashEntry.entityType}.');
      }

      await (_db.update(_db.trashBin)..where((tbl) => tbl.id.equals(trashId))).write(
        TrashBinCompanion(restoredAt: Value(now)),
      );
    });

    await recordAudit(
      _db,
      actionType: 'trash.restore',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: trashEntry.entityType,
      entityId: trashEntry.entityId,
      message: 'Entity restored from trash',
    );
  }

  Future<void> _restoreSoftDeleted<T extends Table, D>(
    TableInfo<T, D> table,
    String entityId,
    String now,
  ) async {
    await _db.customStatement(
      'UPDATE ${table.actualTableName} '
      'SET is_deleted = 0, deleted_at = NULL, updated_at = ?, version = version + 1 '
      'WHERE id = ?;',
      [now, entityId],
    );
  }
}

class ReferencePackageRepository {
  ReferencePackageRepository(this._db, this._paths);

  final AppDatabase _db;
  final AppPaths _paths;

  Future<List<SyncQueueData>> listQueueEntries() {
    return (_db.select(_db.syncQueue)
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.createdAt),
          ]))
        .get();
  }

  Future<DeviceInfoData?> loadDeviceInfo() {
    return _db.select(_db.deviceInfo).getSingleOrNull();
  }

  Future<ReferencePackageResult> exportPackage({
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageSync,
      deniedMessage: 'Only administrators can publish reference packages.',
    );
    final packageId = generateId('reference');
    final exportDir = Directory(
      p.join(_paths.syncOutgoingDir.path, 'reference_$packageId'),
    );
    final dataDir = Directory(p.join(exportDir.path, 'data'));
    await dataDir.create(recursive: true);

    final users = await (_db.select(_db.users)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    final departments = await (_db.select(_db.departments)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    final workshops = await (_db.select(_db.workshops)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    final sections = await (_db.select(_db.sections)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    final objects = await (_db.select(_db.catalogObjects)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    final relations = await (_db.select(_db.objectRelations)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    final components = await (_db.select(_db.components)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    final componentImages = await (_db.select(_db.componentImages)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    final checklists = await (_db.select(_db.checklists)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    final checklistItems = await (_db.select(_db.checklistItems)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    final checklistBindings = await (_db.select(_db.checklistBindings)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();

    final payloads = <String, Object>{
      'users.json': users.map(_userToJson).toList(growable: false),
      'org_structure.json': {
        'departments': departments.map(_departmentToJson).toList(growable: false),
        'workshops': workshops.map(_workshopToJson).toList(growable: false),
        'sections': sections.map(_sectionToJson).toList(growable: false),
      },
      'objects.json': objects.map(_objectToJson).toList(growable: false),
      'object_relations.json':
          relations.map(_relationToJson).toList(growable: false),
      'components.json': components.map(_componentToJson).toList(growable: false),
      'component_images.json':
          componentImages.map(_componentImageToJson).toList(growable: false),
      'checklists.json': checklists.map(_checklistToJson).toList(growable: false),
      'checklist_items.json':
          checklistItems.map(_checklistItemToJson).toList(growable: false),
      'checklist_bindings.json':
          checklistBindings.map(_checklistBindingToJson).toList(growable: false),
      'versions.json': {
        'db_schema_version': _db.schemaVersion,
        'sync_schema_version': '1',
      },
    };

    for (final entry in payloads.entries) {
      final file = File(p.join(dataDir.path, entry.key));
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(entry.value),
      );
    }

    final requiredMedia = componentImages
        .where((image) => (image.localPath ?? '').isNotEmpty)
        .map(
          (image) => {
            'component_id': image.componentId,
            'media_key': image.mediaKey,
            'local_path': image.localPath,
            'checksum': image.checksum,
          },
        )
        .toList(growable: false);

    final manifest = {
      'package_id': packageId,
      'package_type': 'reference',
      'schema_version': '1',
      'created_at': nowIso(),
      'source_device_id': 'current-device',
      'snapshot_version': _db.schemaVersion,
      'entities': {
        'users': users.length,
        'departments': departments.length,
        'workshops': workshops.length,
        'sections': sections.length,
        'objects': objects.length,
        'object_relations': relations.length,
        'components': components.length,
        'component_images': componentImages.length,
        'checklists': checklists.length,
        'checklist_items': checklistItems.length,
        'checklist_bindings': checklistBindings.length,
      },
      'required_media': requiredMedia,
    };

    final manifestBytes = utf8.encode(jsonEncode(manifest));
    final manifestWithChecksum = {
      ...manifest,
      'checksum': checksumBytes(manifestBytes),
    };
    final manifestFile = File(p.join(exportDir.path, 'manifest.json'));
    await manifestFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(manifestWithChecksum),
    );

    final queueRecordId = generateId('queue');
    await _db.into(_db.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: queueRecordId,
            direction: 'outgoing',
            packageType: 'reference',
            packageId: packageId,
            localPath: _paths.relativeToRoot(exportDir.path),
            status: 'pending',
            createdAt: nowIso(),
            updatedAt: nowIso(),
          ),
        );

    await recordAudit(
      _db,
      actionType: 'reference_package.export',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'reference_package',
      entityId: packageId,
      message: 'Reference package exported to local sync/outgoing',
    );

    return ReferencePackageResult(
      packageId: packageId,
      exportDirectory: exportDir,
      queueRecordId: queueRecordId,
    );
  }

  Map<String, Object?> _userToJson(User user) => {
        'id': user.id,
        'full_name': user.fullName,
        'short_name': user.shortName,
        'role_id': user.roleId,
        'is_active': user.isActive,
        'version': user.version,
        'created_at': user.createdAt,
        'updated_at': user.updatedAt,
      };

  Map<String, Object?> _departmentToJson(Department row) => {
        'id': row.id,
        'name': row.name,
        'code': row.code,
        'sort_order': row.sortOrder,
        'version': row.version,
        'created_at': row.createdAt,
        'updated_at': row.updatedAt,
      };

  Map<String, Object?> _workshopToJson(Workshop row) => {
        'id': row.id,
        'department_id': row.departmentId,
        'name': row.name,
        'code': row.code,
        'sort_order': row.sortOrder,
        'version': row.version,
        'created_at': row.createdAt,
        'updated_at': row.updatedAt,
      };

  Map<String, Object?> _sectionToJson(Section row) => {
        'id': row.id,
        'workshop_id': row.workshopId,
        'name': row.name,
        'code': row.code,
        'sort_order': row.sortOrder,
        'version': row.version,
        'created_at': row.createdAt,
        'updated_at': row.updatedAt,
      };

  Map<String, Object?> _objectToJson(CatalogObject row) => {
        'id': row.id,
        'type': row.type,
        'section_id': row.sectionId,
        'parent_id': row.parentId,
        'name': row.name,
        'code': row.code,
        'description': row.description,
        'sort_order': row.sortOrder,
        'is_active': row.isActive,
        'version': row.version,
        'created_at': row.createdAt,
        'updated_at': row.updatedAt,
      };

  Map<String, Object?> _relationToJson(ObjectRelation row) => {
        'id': row.id,
        'parent_object_id': row.parentObjectId,
        'child_object_id': row.childObjectId,
        'relation_type': row.relationType,
        'sort_order': row.sortOrder,
        'version': row.version,
        'created_at': row.createdAt,
        'updated_at': row.updatedAt,
      };

  Map<String, Object?> _componentToJson(Component row) => {
        'id': row.id,
        'object_id': row.objectId,
        'name': row.name,
        'code': row.code,
        'description': row.description,
        'sort_order': row.sortOrder,
        'is_required': row.isRequired,
        'version': row.version,
        'created_at': row.createdAt,
        'updated_at': row.updatedAt,
      };

  Map<String, Object?> _componentImageToJson(ComponentImage row) => {
        'id': row.id,
        'component_id': row.componentId,
        'file_name': row.fileName,
        'media_key': row.mediaKey,
        'local_path': row.localPath,
        'checksum': row.checksum,
        'mime_type': row.mimeType,
        'sort_order': row.sortOrder,
        'version': row.version,
        'created_at': row.createdAt,
        'updated_at': row.updatedAt,
      };

  Map<String, Object?> _checklistToJson(Checklist row) => {
        'id': row.id,
        'name': row.name,
        'description': row.description,
        'is_active': row.isActive,
        'version': row.version,
        'created_at': row.createdAt,
        'updated_at': row.updatedAt,
      };

  Map<String, Object?> _checklistItemToJson(ChecklistItem row) => {
        'id': row.id,
        'checklist_id': row.checklistId,
        'component_id': row.componentId,
        'title': row.title,
        'description': row.description,
        'expected_result': row.expectedResult,
        'result_type': row.resultType,
        'is_required': row.isRequired,
        'sort_order': row.sortOrder,
        'version': row.version,
        'created_at': row.createdAt,
        'updated_at': row.updatedAt,
      };

  Map<String, Object?> _checklistBindingToJson(ChecklistBinding row) => {
        'id': row.id,
        'checklist_id': row.checklistId,
        'target_type': row.targetType,
        'target_id': row.targetId,
        'target_object_type': row.targetObjectType,
        'priority': row.priority,
        'is_required': row.isRequired,
        'version': row.version,
        'created_at': row.createdAt,
        'updated_at': row.updatedAt,
      };
}
