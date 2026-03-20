import 'dart:math';

import 'package:drift/drift.dart' hide Component;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_permissions.dart';
import '../../../data/sqlite/app_database.dart';
import '../../../data/sqlite/database_provider.dart';
import '../../../data/sqlite/repository_support.dart';

export '../../../data/sqlite/app_database.dart'
    show
        CatalogObject,
        Checklist,
        ChecklistBinding,
        ChecklistItem,
        Component,
        Department,
        Section,
        Workshop;

const objectTypeOptions = <String>[
  'product',
  'machine',
  'place',
  'node',
  'detail',
];

const checklistResultTypeOptions = <String>[
  'pass_fail_na',
  'pass_fail',
  'text',
  'number',
];

const checklistBindingTypeOptions = <String>[
  'object',
  'object_type',
  'product',
];

final enterpriseStructureRepositoryProvider =
    Provider<EnterpriseStructureRepository>(
  (ref) => EnterpriseStructureRepository(ref.watch(appDatabaseProvider)),
);

final objectsRepositoryProvider = Provider<ObjectsRepository>(
  (ref) => ObjectsRepository(ref.watch(appDatabaseProvider)),
);

final componentsRepositoryProvider = Provider<ComponentsRepository>(
  (ref) => ComponentsRepository(ref.watch(appDatabaseProvider)),
);

final checklistsRepositoryProvider = Provider<ChecklistsRepository>(
  (ref) => ChecklistsRepository(ref.watch(appDatabaseProvider)),
);

final structureTreeProvider = FutureProvider<List<DepartmentNode>>(
  (ref) => ref.watch(enterpriseStructureRepositoryProvider).loadTree(),
);

final objectsViewDataProvider = FutureProvider<ObjectsViewData>(
  (ref) => ref.watch(objectsRepositoryProvider).loadViewData(),
);

final activeObjectsProvider = FutureProvider<List<CatalogObject>>(
  (ref) => ref.watch(objectsRepositoryProvider).listActiveObjects(),
);

final activeSectionsProvider = FutureProvider<List<Section>>(
  (ref) => ref.watch(objectsRepositoryProvider).listActiveSections(),
);

final componentsScreenDataProvider = FutureProvider<ComponentsScreenData>(
  (ref) => ref.watch(componentsRepositoryProvider).loadScreenData(),
);

final componentsByObjectProvider =
    FutureProvider.family<List<Component>, String?>((ref, objectId) {
  if (objectId == null || objectId.isEmpty) {
    return Future.value(const []);
  }

  return ref.watch(componentsRepositoryProvider).listByObject(objectId);
});

final checklistsProvider = FutureProvider<List<Checklist>>(
  (ref) => ref.watch(checklistsRepositoryProvider).listChecklists(),
);

final checklistDetailProvider =
    FutureProvider.family<ChecklistEditorData?, String>((ref, checklistId) {
  return ref.watch(checklistsRepositoryProvider).getChecklistDetail(checklistId);
});

final checklistReferenceDataProvider = FutureProvider<ChecklistReferenceData>(
  (ref) => ref.watch(checklistsRepositoryProvider).loadReferenceData(),
);

class DepartmentNode {
  const DepartmentNode({
    required this.department,
    required this.workshops,
  });

  final Department department;
  final List<WorkshopNode> workshops;
}

class WorkshopNode {
  const WorkshopNode({
    required this.workshop,
    required this.sections,
  });

  final Workshop workshop;
  final List<Section> sections;
}

class ObjectTreeNode {
  const ObjectTreeNode({
    required this.object,
    required this.children,
  });

  final CatalogObject object;
  final List<ObjectTreeNode> children;
}

class ObjectsViewData {
  const ObjectsViewData({
    required this.roots,
    required this.allObjects,
    required this.sections,
  });

  final List<ObjectTreeNode> roots;
  final List<CatalogObject> allObjects;
  final List<Section> sections;
}

class ComponentsScreenData {
  const ComponentsScreenData({
    required this.objects,
  });

  final List<CatalogObject> objects;
}

class ChecklistEditorData {
  const ChecklistEditorData({
    required this.checklist,
    required this.items,
    required this.bindings,
  });

  final Checklist checklist;
  final List<ChecklistItem> items;
  final List<ChecklistBinding> bindings;
}

class ChecklistReferenceData {
  const ChecklistReferenceData({
    required this.objects,
    required this.components,
  });

  final List<CatalogObject> objects;
  final List<Component> components;
}

String? _nullableText(String? value) {
  if (value == null) {
    return null;
  }

  final cleaned = value.trim();
  return cleaned.isEmpty ? null : cleaned;
}

String _nowIso() => DateTime.now().toUtc().toIso8601String();

final Random _random = Random();

String _generateId(String prefix) {
  final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch.toRadixString(
        36,
      );
  final suffix = _random.nextInt(1 << 32).toRadixString(36);
  return '$prefix-$timestamp-$suffix';
}

class EnterpriseStructureRepository {
  EnterpriseStructureRepository(this._db);

  final AppDatabase _db;

  Future<List<DepartmentNode>> loadTree() async {
    final departments = await (_db.select(_db.departments)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
    final workshops = await (_db.select(_db.workshops)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
    final sections = await (_db.select(_db.sections)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();

    final sectionsByWorkshop = <String, List<Section>>{};
    for (final section in sections) {
      sectionsByWorkshop.putIfAbsent(section.workshopId, () => []).add(section);
    }

    final workshopsByDepartment = <String, List<WorkshopNode>>{};
    for (final workshop in workshops) {
      workshopsByDepartment.putIfAbsent(workshop.departmentId, () => []).add(
            WorkshopNode(
              workshop: workshop,
              sections: sectionsByWorkshop[workshop.id] ?? const [],
            ),
          );
    }

    return departments
        .map(
          (department) => DepartmentNode(
            department: department,
            workshops: workshopsByDepartment[department.id] ?? const [],
          ),
        )
        .toList(growable: false);
  }

  Future<void> saveDepartment({
    String? id,
    required String name,
    String? code,
    required int sortOrder,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять структуру предприятия.',
    );
    final now = _nowIso();
    final cleanedCode = _nullableText(code);

    if (id == null) {
      final departmentId = _generateId('department');
      await _db.into(_db.departments).insert(
            DepartmentsCompanion.insert(
              id: departmentId,
              name: name.trim(),
              code: Value(cleanedCode),
              sortOrder: Value(sortOrder),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await recordAudit(
        _db,
        actionType: 'department.create',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'department',
        entityId: departmentId,
        message: 'Department created',
      );
      return;
    }

    final existing = await _getDepartment(id);
    await (_db.update(_db.departments)..where((tbl) => tbl.id.equals(id))).write(
      DepartmentsCompanion(
        name: Value(name.trim()),
        code: Value(cleanedCode),
        sortOrder: Value(sortOrder),
        version: Value(existing.version + 1),
        updatedAt: Value(now),
      ),
    );
    await recordAudit(
      _db,
      actionType: 'department.update',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'department',
      entityId: id,
      message: 'Department updated',
    );
  }

  Future<void> deleteDepartment(String id, {String? actorUserId}) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять структуру предприятия.',
    );
    final activeWorkshops = await (_db.select(_db.workshops)
          ..where(
            (tbl) => tbl.departmentId.equals(id) & tbl.isDeleted.equals(false),
          ))
        .get();

    if (activeWorkshops.isNotEmpty) {
      throw StateError('Нельзя удалить подразделение, пока в нем есть цеха.');
    }

    final existing = await _getDepartment(id);
    final now = _nowIso();
    await (_db.update(_db.departments)..where((tbl) => tbl.id.equals(id))).write(
      DepartmentsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
        version: Value(existing.version + 1),
      ),
    );
    await addTrashEntry(
      _db,
      entityType: 'department',
      entityId: id,
      displayName: existing.name,
      deletedByUserId: actorUserId,
      deletedAt: now,
      snapshot: {'id': existing.id, 'name': existing.name, 'code': existing.code},
    );
    await recordAudit(
      _db,
      actionType: 'department.delete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'department',
      entityId: id,
      message: 'Department moved to trash',
    );
  }

  Future<void> saveWorkshop({
    String? id,
    required String departmentId,
    required String name,
    String? code,
    required int sortOrder,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять структуру предприятия.',
    );
    final now = _nowIso();
    final cleanedCode = _nullableText(code);

    if (id == null) {
      final workshopId = _generateId('workshop');
      await _db.into(_db.workshops).insert(
            WorkshopsCompanion.insert(
              id: workshopId,
              departmentId: departmentId,
              name: name.trim(),
              code: Value(cleanedCode),
              sortOrder: Value(sortOrder),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await recordAudit(
        _db,
        actionType: 'workshop.create',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'workshop',
        entityId: workshopId,
        message: 'Workshop created',
      );
      return;
    }

    final existing = await _getWorkshop(id);
    await (_db.update(_db.workshops)..where((tbl) => tbl.id.equals(id))).write(
      WorkshopsCompanion(
        departmentId: Value(departmentId),
        name: Value(name.trim()),
        code: Value(cleanedCode),
        sortOrder: Value(sortOrder),
        version: Value(existing.version + 1),
        updatedAt: Value(now),
      ),
    );
    await recordAudit(
      _db,
      actionType: 'workshop.update',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'workshop',
      entityId: id,
      message: 'Workshop updated',
    );
  }

  Future<void> deleteWorkshop(String id, {String? actorUserId}) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять структуру предприятия.',
    );
    final activeSections = await (_db.select(_db.sections)
          ..where(
            (tbl) => tbl.workshopId.equals(id) & tbl.isDeleted.equals(false),
          ))
        .get();

    if (activeSections.isNotEmpty) {
      throw StateError('Нельзя удалить цех, пока в нем есть участки.');
    }

    final existing = await _getWorkshop(id);
    final now = _nowIso();
    await (_db.update(_db.workshops)..where((tbl) => tbl.id.equals(id))).write(
      WorkshopsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
        version: Value(existing.version + 1),
      ),
    );
    await addTrashEntry(
      _db,
      entityType: 'workshop',
      entityId: id,
      displayName: existing.name,
      deletedByUserId: actorUserId,
      deletedAt: now,
      snapshot: {
        'id': existing.id,
        'department_id': existing.departmentId,
        'name': existing.name,
        'code': existing.code,
      },
    );
    await recordAudit(
      _db,
      actionType: 'workshop.delete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'workshop',
      entityId: id,
      message: 'Workshop moved to trash',
    );
  }

  Future<void> saveSection({
    String? id,
    required String workshopId,
    required String name,
    String? code,
    required int sortOrder,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять структуру предприятия.',
    );
    final now = _nowIso();
    final cleanedCode = _nullableText(code);

    if (id == null) {
      final sectionId = _generateId('section');
      await _db.into(_db.sections).insert(
            SectionsCompanion.insert(
              id: sectionId,
              workshopId: workshopId,
              name: name.trim(),
              code: Value(cleanedCode),
              sortOrder: Value(sortOrder),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await recordAudit(
        _db,
        actionType: 'section.create',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'section',
        entityId: sectionId,
        message: 'Section created',
      );
      return;
    }

    final existing = await _getSection(id);
    await (_db.update(_db.sections)..where((tbl) => tbl.id.equals(id))).write(
      SectionsCompanion(
        workshopId: Value(workshopId),
        name: Value(name.trim()),
        code: Value(cleanedCode),
        sortOrder: Value(sortOrder),
        version: Value(existing.version + 1),
        updatedAt: Value(now),
      ),
    );
    await recordAudit(
      _db,
      actionType: 'section.update',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'section',
      entityId: id,
      message: 'Section updated',
    );
  }

  Future<void> deleteSection(String id, {String? actorUserId}) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять структуру предприятия.',
    );
    final activeObjects = await (_db.select(_db.catalogObjects)
          ..where(
            (tbl) => tbl.sectionId.equals(id) & tbl.isDeleted.equals(false),
          ))
        .get();

    if (activeObjects.isNotEmpty) {
      throw StateError('Нельзя удалить участок, пока к нему привязаны объекты.');
    }

    final existing = await _getSection(id);
    final now = _nowIso();
    await (_db.update(_db.sections)..where((tbl) => tbl.id.equals(id))).write(
      SectionsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
        version: Value(existing.version + 1),
      ),
    );
    await addTrashEntry(
      _db,
      entityType: 'section',
      entityId: id,
      displayName: existing.name,
      deletedByUserId: actorUserId,
      deletedAt: now,
      snapshot: {
        'id': existing.id,
        'workshop_id': existing.workshopId,
        'name': existing.name,
        'code': existing.code,
      },
    );
    await recordAudit(
      _db,
      actionType: 'section.delete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'section',
      entityId: id,
      message: 'Section moved to trash',
    );
  }

  Future<Department> _getDepartment(String id) {
    return (_db.select(_db.departments)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<Workshop> _getWorkshop(String id) {
    return (_db.select(_db.workshops)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<Section> _getSection(String id) {
    return (_db.select(_db.sections)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }
}

class ObjectsRepository {
  ObjectsRepository(this._db);

  final AppDatabase _db;

  Future<ObjectsViewData> loadViewData() async {
    final allObjects = await listActiveObjects();
    final sections = await listActiveSections();
    final childrenByParent = <String?, List<CatalogObject>>{};

    for (final object in allObjects) {
      childrenByParent.putIfAbsent(object.parentId, () => []).add(object);
    }

    List<ObjectTreeNode> buildNodes(String? parentId) {
      final children = childrenByParent[parentId] ?? const <CatalogObject>[];
      return children
          .map(
            (object) => ObjectTreeNode(
              object: object,
              children: buildNodes(object.id),
            ),
          )
          .toList(growable: false);
    }

    return ObjectsViewData(
      roots: buildNodes(null),
      allObjects: allObjects,
      sections: sections,
    );
  }

  Future<List<CatalogObject>> listActiveObjects() {
    return (_db.select(_db.catalogObjects)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
  }

  Future<List<Section>> listActiveSections() {
    return (_db.select(_db.sections)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
  }

  Future<void> saveObject({
    String? id,
    required String type,
    String? sectionId,
    String? parentId,
    required String name,
    String? code,
    String? description,
    required int sortOrder,
    required bool isActive,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять объекты справочника.',
    );
    final now = _nowIso();
    final cleanedSectionId = _nullableText(sectionId);
    final cleanedParentId = _nullableText(parentId);
    final cleanedCode = _nullableText(code);
    final cleanedDescription = _nullableText(description);

    if (id != null && cleanedParentId == id) {
      throw StateError('Объект нельзя сделать родителем самому себе.');
    }

    if (id != null && cleanedParentId != null) {
      final hasCycle = await _wouldCreateCycle(
        objectId: id,
        parentCandidateId: cleanedParentId,
      );
      if (hasCycle) {
        throw StateError('Выбранный родитель создает цикл в дереве объектов.');
      }
    }

    await _db.transaction(() async {
      if (id == null) {
        final newId = _generateId('object');
        await _db.into(_db.catalogObjects).insert(
              CatalogObjectsCompanion.insert(
                id: newId,
                type: type,
                sectionId: Value(cleanedSectionId),
                parentId: Value(cleanedParentId),
                name: name.trim(),
                code: Value(cleanedCode),
                description: Value(cleanedDescription),
                sortOrder: Value(sortOrder),
                isActive: Value(isActive),
                createdAt: now,
                updatedAt: now,
              ),
            );
        await _replaceParentRelation(
          childId: newId,
          newParentId: cleanedParentId,
        );
        await recordAudit(
          _db,
          actionType: 'object.create',
          resultStatus: 'success',
          userId: actorUserId,
          entityType: 'object',
          entityId: newId,
          message: 'Object created',
        );
        return;
      }

      final existing = await _getObject(id);
      await (_db.update(_db.catalogObjects)
            ..where((tbl) => tbl.id.equals(id)))
          .write(
        CatalogObjectsCompanion(
          type: Value(type),
          sectionId: Value(cleanedSectionId),
          parentId: Value(cleanedParentId),
          name: Value(name.trim()),
          code: Value(cleanedCode),
          description: Value(cleanedDescription),
          sortOrder: Value(sortOrder),
          isActive: Value(isActive),
          version: Value(existing.version + 1),
          updatedAt: Value(now),
        ),
      );
      await _replaceParentRelation(
        childId: id,
        newParentId: cleanedParentId,
      );
      await recordAudit(
        _db,
        actionType: 'object.update',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'object',
        entityId: id,
        message: 'Object updated',
      );
    });
  }

  Future<void> deleteObject(String id, {String? actorUserId}) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять объекты справочника.',
    );
    final children = await (_db.select(_db.catalogObjects)
          ..where(
            (tbl) => tbl.parentId.equals(id) & tbl.isDeleted.equals(false),
          ))
        .get();
    if (children.isNotEmpty) {
      throw StateError('Нельзя удалить объект, пока у него есть дочерние узлы.');
    }

    final components = await (_db.select(_db.components)
          ..where((tbl) => tbl.objectId.equals(id) & tbl.isDeleted.equals(false)))
        .get();
    if (components.isNotEmpty) {
      throw StateError('Нельзя удалить объект, пока у него есть компоненты.');
    }

    final existing = await _getObject(id);
    final now = _nowIso();
    await _db.transaction(() async {
      await (_db.update(_db.catalogObjects)
            ..where((tbl) => tbl.id.equals(id)))
          .write(
        CatalogObjectsCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
            version: Value(existing.version + 1),
        ),
      );

      final relations = await (_db.select(_db.objectRelations)
            ..where(
              (tbl) =>
                  tbl.childObjectId.equals(id) & tbl.isDeleted.equals(false),
            ))
          .get();

      for (final relation in relations) {
        await (_db.update(_db.objectRelations)
              ..where((tbl) => tbl.id.equals(relation.id)))
            .write(
          ObjectRelationsCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
            version: Value(relation.version + 1),
              ),
            );
      }
    });
    await addTrashEntry(
      _db,
      entityType: 'object',
      entityId: id,
      displayName: existing.name,
      deletedByUserId: actorUserId,
      deletedAt: now,
      snapshot: {
        'id': existing.id,
        'type': existing.type,
        'name': existing.name,
        'parent_id': existing.parentId,
      },
    );
    await recordAudit(
      _db,
      actionType: 'object.delete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'object',
      entityId: id,
      message: 'Object moved to trash',
    );
  }

  Future<void> _replaceParentRelation({
    required String childId,
    required String? newParentId,
  }) async {
    final now = _nowIso();
    final existingRelations = await (_db.select(_db.objectRelations)
          ..where(
            (tbl) =>
                tbl.childObjectId.equals(childId) & tbl.isDeleted.equals(false),
          ))
        .get();

    for (final relation in existingRelations) {
      await (_db.update(_db.objectRelations)
            ..where((tbl) => tbl.id.equals(relation.id)))
          .write(
        ObjectRelationsCompanion(
          isDeleted: const Value(true),
          deletedAt: Value(now),
          updatedAt: Value(now),
          version: Value(relation.version + 1),
        ),
      );
    }

    if (newParentId == null) {
      return;
    }

    await _db.into(_db.objectRelations).insert(
          ObjectRelationsCompanion.insert(
            id: _generateId('relation'),
            parentObjectId: newParentId,
            childObjectId: childId,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<bool> _wouldCreateCycle({
    required String objectId,
    required String parentCandidateId,
  }) async {
    final objects = await listActiveObjects();
    final byId = {for (final object in objects) object.id: object};
    String? currentId = parentCandidateId;

    while (currentId != null) {
      if (currentId == objectId) {
        return true;
      }
      currentId = byId[currentId]?.parentId;
    }

    return false;
  }

  Future<CatalogObject> _getObject(String id) {
    return (_db.select(_db.catalogObjects)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }
}

class ComponentsRepository {
  ComponentsRepository(this._db);

  final AppDatabase _db;

  Future<ComponentsScreenData> loadScreenData() async {
    final objects = await (_db.select(_db.catalogObjects)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();

    return ComponentsScreenData(objects: objects);
  }

  Future<List<Component>> listByObject(String objectId) {
    return (_db.select(_db.components)
          ..where(
            (tbl) => tbl.objectId.equals(objectId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
  }

  Future<void> saveComponent({
    String? id,
    required String objectId,
    required String name,
    String? code,
    String? description,
    required int sortOrder,
    required bool isRequired,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять компоненты.',
    );
    final now = _nowIso();
    final cleanedCode = _nullableText(code);
    final cleanedDescription = _nullableText(description);

    if (id == null) {
      final componentId = _generateId('component');
      await _db.into(_db.components).insert(
            ComponentsCompanion.insert(
              id: componentId,
              objectId: objectId,
              name: name.trim(),
              code: Value(cleanedCode),
              description: Value(cleanedDescription),
              sortOrder: Value(sortOrder),
              isRequired: Value(isRequired),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await recordAudit(
        _db,
        actionType: 'component.create',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'component',
        entityId: componentId,
        message: 'Component created',
      );
      return;
    }

    final existing = await _getComponent(id);
    await (_db.update(_db.components)..where((tbl) => tbl.id.equals(id))).write(
      ComponentsCompanion(
        objectId: Value(objectId),
        name: Value(name.trim()),
        code: Value(cleanedCode),
        description: Value(cleanedDescription),
        sortOrder: Value(sortOrder),
        isRequired: Value(isRequired),
        version: Value(existing.version + 1),
        updatedAt: Value(now),
      ),
    );
    await recordAudit(
      _db,
      actionType: 'component.update',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'component',
      entityId: id,
      message: 'Component updated',
    );
  }

  Future<void> deleteComponent(String id, {String? actorUserId}) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять компоненты.',
    );
    final checklistItems = await (_db.select(_db.checklistItems)
          ..where(
            (tbl) => tbl.componentId.equals(id) & tbl.isDeleted.equals(false),
          ))
        .get();

    if (checklistItems.isNotEmpty) {
      throw StateError('Нельзя удалить компонент, пока он используется в чек-листе.');
    }

    final existing = await _getComponent(id);
    final now = _nowIso();
    await (_db.update(_db.components)..where((tbl) => tbl.id.equals(id))).write(
      ComponentsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
        version: Value(existing.version + 1),
      ),
    );
    await addTrashEntry(
      _db,
      entityType: 'component',
      entityId: id,
      displayName: existing.name,
      deletedByUserId: actorUserId,
      deletedAt: now,
      snapshot: {
        'id': existing.id,
        'object_id': existing.objectId,
        'name': existing.name,
        'code': existing.code,
      },
    );
    await recordAudit(
      _db,
      actionType: 'component.delete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'component',
      entityId: id,
      message: 'Component moved to trash',
    );
  }

  Future<Component> _getComponent(String id) {
    return (_db.select(_db.components)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }
}

class ChecklistsRepository {
  ChecklistsRepository(this._db);

  final AppDatabase _db;

  Future<List<Checklist>> listChecklists() {
    return (_db.select(_db.checklists)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
  }

  Future<ChecklistEditorData?> getChecklistDetail(String checklistId) async {
    final checklist = await (_db.select(_db.checklists)
          ..where(
            (tbl) => tbl.id.equals(checklistId) & tbl.isDeleted.equals(false),
          ))
        .getSingleOrNull();

    if (checklist == null) {
      return null;
    }

    final items = await (_db.select(_db.checklistItems)
          ..where(
            (tbl) =>
                tbl.checklistId.equals(checklistId) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.title),
          ]))
        .get();

    final bindings = await (_db.select(_db.checklistBindings)
          ..where(
            (tbl) =>
                tbl.checklistId.equals(checklistId) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.priority),
          ]))
        .get();

    return ChecklistEditorData(
      checklist: checklist,
      items: items,
      bindings: bindings,
    );
  }

  Future<ChecklistReferenceData> loadReferenceData() async {
    final objects = await (_db.select(_db.catalogObjects)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
    final components = await (_db.select(_db.components)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();

    return ChecklistReferenceData(objects: objects, components: components);
  }

  Future<String> saveChecklist({
    String? id,
    required String name,
    String? description,
    required bool isActive,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять чек-листы.',
    );
    final now = _nowIso();
    final cleanedDescription = _nullableText(description);

    if (id == null) {
      final newId = _generateId('checklist');
      await _db.into(_db.checklists).insert(
            ChecklistsCompanion.insert(
              id: newId,
              name: name.trim(),
              description: Value(cleanedDescription),
              isActive: Value(isActive),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await recordAudit(
        _db,
        actionType: 'checklist.create',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'checklist',
        entityId: newId,
        message: 'Checklist created',
      );
      return newId;
    }

    final existing = await _getChecklist(id);
    await (_db.update(_db.checklists)..where((tbl) => tbl.id.equals(id))).write(
      ChecklistsCompanion(
        name: Value(name.trim()),
        description: Value(cleanedDescription),
        isActive: Value(isActive),
        version: Value(existing.version + 1),
        updatedAt: Value(now),
      ),
    );
    await recordAudit(
      _db,
      actionType: 'checklist.update',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'checklist',
      entityId: id,
      message: 'Checklist updated',
    );
    return id;
  }

  Future<void> deleteChecklist(String id, {String? actorUserId}) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять чек-листы.',
    );
    final checklist = await _getChecklist(id);
    final now = _nowIso();

    await _db.transaction(() async {
      await (_db.update(_db.checklists)..where((tbl) => tbl.id.equals(id))).write(
        ChecklistsCompanion(
          isDeleted: const Value(true),
          deletedAt: Value(now),
          updatedAt: Value(now),
          version: Value(checklist.version + 1),
        ),
      );

      final items = await (_db.select(_db.checklistItems)
            ..where(
              (tbl) => tbl.checklistId.equals(id) & tbl.isDeleted.equals(false),
            ))
          .get();
      for (final item in items) {
        await (_db.update(_db.checklistItems)
              ..where((tbl) => tbl.id.equals(item.id)))
            .write(
          ChecklistItemsCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
            version: Value(item.version + 1),
          ),
        );
      }

      final bindings = await (_db.select(_db.checklistBindings)
            ..where(
              (tbl) => tbl.checklistId.equals(id) & tbl.isDeleted.equals(false),
            ))
          .get();
      for (final binding in bindings) {
        await (_db.update(_db.checklistBindings)
              ..where((tbl) => tbl.id.equals(binding.id)))
            .write(
          ChecklistBindingsCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
            version: Value(binding.version + 1),
          ),
        );
      }
    });
    await addTrashEntry(
      _db,
      entityType: 'checklist',
      entityId: id,
      displayName: checklist.name,
      deletedByUserId: actorUserId,
      deletedAt: now,
      snapshot: {'id': checklist.id, 'name': checklist.name},
    );
    await recordAudit(
      _db,
      actionType: 'checklist.delete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'checklist',
      entityId: id,
      message: 'Checklist moved to trash',
    );
  }

  Future<void> saveChecklistItem({
    String? id,
    required String checklistId,
    String? componentId,
    required String title,
    String? description,
    String? expectedResult,
    required String resultType,
    required bool isRequired,
    required int sortOrder,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять пункты чек-листа.',
    );
    final now = _nowIso();
    final cleanedComponentId = _nullableText(componentId);
    final cleanedDescription = _nullableText(description);
    final cleanedExpectedResult = _nullableText(expectedResult);

    if (id == null) {
      final itemId = _generateId('checkitem');
      await _db.into(_db.checklistItems).insert(
            ChecklistItemsCompanion.insert(
              id: itemId,
              checklistId: checklistId,
              componentId: Value(cleanedComponentId),
              title: title.trim(),
              description: Value(cleanedDescription),
              expectedResult: Value(cleanedExpectedResult),
              resultType: Value(resultType),
              isRequired: Value(isRequired),
              sortOrder: Value(sortOrder),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await recordAudit(
        _db,
        actionType: 'checklist_item.create',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'checklist_item',
        entityId: itemId,
        message: 'Checklist item created',
      );
      return;
    }

    final existing = await _getChecklistItem(id);
    await (_db.update(_db.checklistItems)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      ChecklistItemsCompanion(
        componentId: Value(cleanedComponentId),
        title: Value(title.trim()),
        description: Value(cleanedDescription),
        expectedResult: Value(cleanedExpectedResult),
        resultType: Value(resultType),
        isRequired: Value(isRequired),
        sortOrder: Value(sortOrder),
        version: Value(existing.version + 1),
        updatedAt: Value(now),
      ),
    );
    await recordAudit(
      _db,
      actionType: 'checklist_item.update',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'checklist_item',
      entityId: id,
      message: 'Checklist item updated',
    );
  }

  Future<void> deleteChecklistItem(String id, {String? actorUserId}) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять пункты чек-листа.',
    );
    final existing = await _getChecklistItem(id);
    final now = _nowIso();
    await (_db.update(_db.checklistItems)..where((tbl) => tbl.id.equals(id))).write(
      ChecklistItemsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
        version: Value(existing.version + 1),
      ),
    );
    await addTrashEntry(
      _db,
      entityType: 'checklist_item',
      entityId: id,
      displayName: existing.title,
      deletedByUserId: actorUserId,
      deletedAt: now,
      snapshot: {
        'id': existing.id,
        'checklist_id': existing.checklistId,
        'title': existing.title,
      },
    );
    await recordAudit(
      _db,
      actionType: 'checklist_item.delete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'checklist_item',
      entityId: id,
      message: 'Checklist item moved to trash',
    );
  }

  Future<void> saveChecklistBinding({
    String? id,
    required String checklistId,
    required String targetType,
    String? targetId,
    String? targetObjectType,
    required int priority,
    required bool isRequired,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять привязки чек-листов.',
    );
    final now = _nowIso();
    final cleanedTargetId = _nullableText(targetId);
    final cleanedTargetObjectType = _nullableText(targetObjectType);

    if (targetType == 'object' && cleanedTargetId == null) {
      throw StateError('Для привязки к объекту нужно выбрать конкретный объект.');
    }

    if (targetType == 'product' && cleanedTargetId == null) {
      throw StateError('Для привязки к изделию нужно выбрать изделие.');
    }

    if (targetType == 'object_type' && cleanedTargetObjectType == null) {
      throw StateError('Для привязки по типу нужно выбрать тип объекта.');
    }

    if (id == null) {
      final bindingId = _generateId('binding');
      await _db.into(_db.checklistBindings).insert(
            ChecklistBindingsCompanion.insert(
              id: bindingId,
              checklistId: checklistId,
              targetType: targetType,
              targetId: Value(cleanedTargetId),
              targetObjectType: Value(cleanedTargetObjectType),
              priority: Value(priority),
              isRequired: Value(isRequired),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await recordAudit(
        _db,
        actionType: 'checklist_binding.create',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'checklist_binding',
        entityId: bindingId,
        message: 'Checklist binding created',
      );
      return;
    }

    final existing = await _getChecklistBinding(id);
    await (_db.update(_db.checklistBindings)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      ChecklistBindingsCompanion(
        targetType: Value(targetType),
        targetId: Value(cleanedTargetId),
        targetObjectType: Value(cleanedTargetObjectType),
        priority: Value(priority),
        isRequired: Value(isRequired),
        version: Value(existing.version + 1),
        updatedAt: Value(now),
      ),
    );
    await recordAudit(
      _db,
      actionType: 'checklist_binding.update',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'checklist_binding',
      entityId: id,
      message: 'Checklist binding updated',
    );
  }

  Future<void> deleteChecklistBinding(String id, {String? actorUserId}) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageCatalog,
      deniedMessage: 'Только администратор может изменять привязки чек-листов.',
    );
    final existing = await _getChecklistBinding(id);
    final now = _nowIso();
    await (_db.update(_db.checklistBindings)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      ChecklistBindingsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
        version: Value(existing.version + 1),
      ),
    );
    await addTrashEntry(
      _db,
      entityType: 'checklist_binding',
      entityId: id,
      displayName: '${existing.targetType}:${existing.targetId ?? existing.targetObjectType ?? '-'}',
      deletedByUserId: actorUserId,
      deletedAt: now,
      snapshot: {
        'id': existing.id,
        'checklist_id': existing.checklistId,
        'target_type': existing.targetType,
      },
    );
    await recordAudit(
      _db,
      actionType: 'checklist_binding.delete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'checklist_binding',
      entityId: id,
      message: 'Checklist binding moved to trash',
    );
  }

  Future<Checklist> _getChecklist(String id) {
    return (_db.select(_db.checklists)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<ChecklistItem> _getChecklistItem(String id) {
    return (_db.select(_db.checklistItems)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<ChecklistBinding> _getChecklistBinding(String id) {
    return (_db.select(_db.checklistBindings)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }
}
