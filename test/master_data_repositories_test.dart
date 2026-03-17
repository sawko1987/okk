import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/data/sqlite/app_database.dart';
import 'package:okk_qc_app/features/catalog/data/master_data_repositories.dart';

void main() {
  late AppDatabase database;
  late EnterpriseStructureRepository structureRepository;
  late ObjectsRepository objectsRepository;
  late ComponentsRepository componentsRepository;
  late ChecklistsRepository checklistsRepository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    structureRepository = EnterpriseStructureRepository(database);
    objectsRepository = ObjectsRepository(database);
    componentsRepository = ComponentsRepository(database);
    checklistsRepository = ChecklistsRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('creates and deletes enterprise structure in dependency order', () async {
    await structureRepository.saveDepartment(
      name: 'Механообработка',
      code: 'DEP-1',
      sortOrder: 10,
    );

    final treeAfterDepartment = await structureRepository.loadTree();
    final departmentId = treeAfterDepartment.single.department.id;

    await structureRepository.saveWorkshop(
      departmentId: departmentId,
      name: 'Цех 1',
      code: 'WS-1',
      sortOrder: 20,
    );

    final treeAfterWorkshop = await structureRepository.loadTree();
    final workshopId = treeAfterWorkshop.single.workshops.single.workshop.id;

    await structureRepository.saveSection(
      workshopId: workshopId,
      name: 'Участок А',
      code: 'SEC-A',
      sortOrder: 30,
    );

    final fullTree = await structureRepository.loadTree();
    expect(fullTree, hasLength(1));
    expect(fullTree.single.workshops, hasLength(1));
    expect(fullTree.single.workshops.single.sections, hasLength(1));

    await expectLater(
      () => structureRepository.deleteDepartment(departmentId),
      throwsA(isA<StateError>()),
    );

    final sectionId = fullTree.single.workshops.single.sections.single.id;
    await structureRepository.deleteSection(sectionId);
    await structureRepository.deleteWorkshop(workshopId);
    await structureRepository.deleteDepartment(departmentId);

    expect(await structureRepository.loadTree(), isEmpty);
  });

  test('prevents cycles in object tree', () async {
    await objectsRepository.saveObject(
      type: 'product',
      name: 'Изделие 1',
      sortOrder: 1,
      isActive: true,
    );
    final root = (await objectsRepository.listActiveObjects()).single;

    await objectsRepository.saveObject(
      type: 'machine',
      parentId: root.id,
      name: 'Станок 1',
      sortOrder: 2,
      isActive: true,
    );
    final objects = await objectsRepository.listActiveObjects();
    final child = objects.firstWhere((object) => object.parentId == root.id);

    await expectLater(
      () => objectsRepository.saveObject(
        id: root.id,
        type: root.type,
        sectionId: root.sectionId,
        parentId: child.id,
        name: root.name,
        code: root.code,
        description: root.description,
        sortOrder: root.sortOrder,
        isActive: root.isActive,
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('persists checklist items and blocks component deletion while referenced', () async {
    await objectsRepository.saveObject(
      type: 'product',
      name: 'Изделие 2',
      sortOrder: 1,
      isActive: true,
    );
    final objectId = (await objectsRepository.listActiveObjects()).single.id;

    await componentsRepository.saveComponent(
      objectId: objectId,
      name: 'Подшипник',
      sortOrder: 1,
      isRequired: true,
    );
    final componentId = (await componentsRepository.listByObject(objectId)).single.id;

    final checklistId = await checklistsRepository.saveChecklist(
      name: 'Приемка',
      description: 'Базовый чек-лист',
      isActive: true,
    );

    await checklistsRepository.saveChecklistItem(
      checklistId: checklistId,
      componentId: componentId,
      title: 'Проверить подшипник',
      resultType: 'pass_fail_na',
      isRequired: true,
      sortOrder: 1,
    );
    await checklistsRepository.saveChecklistBinding(
      checklistId: checklistId,
      targetType: 'object',
      targetId: objectId,
      priority: 10,
      isRequired: true,
    );

    final detail = await checklistsRepository.getChecklistDetail(checklistId);
    expect(detail, isNotNull);
    expect(detail!.items, hasLength(1));
    expect(detail.bindings, hasLength(1));

    await expectLater(
      () => componentsRepository.deleteComponent(componentId),
      throwsA(isA<StateError>()),
    );
  });
}
