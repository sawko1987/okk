import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/core/storage/app_paths.dart';
import 'package:okk_qc_app/data/sqlite/app_database.dart';
import 'package:okk_qc_app/features/catalog/data/master_data_repositories.dart';
import 'package:okk_qc_app/features/inspections/data/inspection_repositories.dart';

void main() {
  late AppDatabase database;
  late AppPaths paths;
  late Directory tempRoot;
  late EnterpriseStructureRepository enterpriseStructureRepository;
  late ObjectsRepository objectsRepository;
  late ComponentsRepository componentsRepository;
  late ChecklistsRepository checklistsRepository;
  late InspectionsRepository inspectionsRepository;

  setUp(() async {
    tempRoot = await Directory.systemTemp.createTemp('okk-inspections-test-');
    paths = AppPaths.forTesting(tempRoot.path);
    await paths.ensureCreated();

    database = AppDatabase.forTesting(NativeDatabase.memory());
    enterpriseStructureRepository = EnterpriseStructureRepository(database);
    objectsRepository = ObjectsRepository(database);
    componentsRepository = ComponentsRepository(database);
    checklistsRepository = ChecklistsRepository(database);
    inspectionsRepository = InspectionsRepository(database, paths);

    await database.ensureBootstrapData(
      deviceId: 'android-device-1',
      deviceName: 'android-test',
      platform: 'android',
      appVersion: '1.0.0+1',
      rootPath: tempRoot.path,
    );
  });

  tearDown(() async {
    await database.close();
    if (await tempRoot.exists()) {
      await tempRoot.delete(recursive: true);
    }
  });

  test('lists workshops, products, targets, and component cards for Android selection flow',
      () async {
    await enterpriseStructureRepository.saveDepartment(
      name: 'Production',
      sortOrder: 1,
      actorUserId: 'user-default-admin',
    );
    final department = (await database.select(database.departments).get()).single;

    await enterpriseStructureRepository.saveWorkshop(
      departmentId: department.id,
      name: 'Assembly',
      sortOrder: 1,
      actorUserId: 'user-default-admin',
    );
    final workshop = (await database.select(database.workshops).get()).single;

    await enterpriseStructureRepository.saveSection(
      workshopId: workshop.id,
      name: 'Line 1',
      sortOrder: 1,
      actorUserId: 'user-default-admin',
    );
    final section = (await database.select(database.sections).get()).single;

    await objectsRepository.saveObject(
      type: 'product',
      sectionId: section.id,
      name: 'Pump A',
      sortOrder: 1,
      isActive: true,
      actorUserId: 'user-default-admin',
    );
    final product = (await objectsRepository.listActiveObjects())
        .firstWhere((item) => item.type == 'product');

    await objectsRepository.saveObject(
      type: 'machine',
      sectionId: section.id,
      parentId: product.id,
      name: 'Pump housing',
      sortOrder: 2,
      isActive: true,
      actorUserId: 'user-default-admin',
    );
    final machine = (await objectsRepository.listActiveObjects())
        .firstWhere((item) => item.parentId == product.id);

    await componentsRepository.saveComponent(
      objectId: machine.id,
      name: 'Bearing',
      sortOrder: 1,
      isRequired: true,
      actorUserId: 'user-default-admin',
    );
    final component = (await componentsRepository.listByObject(machine.id)).single;

    final componentDir =
        Directory(paths.resolveRelativePath('media/components/${component.id}'));
    await componentDir.create(recursive: true);
    final imageFile = File('${componentDir.path}${Platform.pathSeparator}bearing.png');
    await imageFile.writeAsBytes(const [1, 2, 3, 4], flush: true);
    final now = DateTime.now().toUtc().toIso8601String();
    final relativeImagePath = paths.componentImageRelativePath(
      component.id,
      'bearing.png',
    );
    await database.into(database.componentImages).insert(
          ComponentImagesCompanion.insert(
            id: 'component-image-1',
            componentId: component.id,
            fileName: 'bearing.png',
            mediaKey: 'bearing-media-key',
            checksum: 'checksum-bearing',
            mimeType: 'image/png',
            createdAt: now,
            updatedAt: now,
            localPath: Value(relativeImagePath),
            sortOrder: const Value(0),
          ),
        );

    final workshops = await inspectionsRepository.listWorkshopsWithProducts();
    expect(workshops, hasLength(1));
    expect(workshops.single.workshopId, workshop.id);
    expect(workshops.single.productCount, 1);

    final products = await inspectionsRepository.listProductsForWorkshop(workshop.id);
    expect(products, hasLength(1));
    expect(products.single.productObjectId, product.id);
    expect(products.single.sectionName, 'Line 1');

    final targets = await inspectionsRepository.listSelectableInspectionTargets(product.id);
    expect(targets.map((item) => item.targetObjectId), contains(machine.id));

    final components = await inspectionsRepository.listComponentsForTarget(machine.id);
    expect(components, hasLength(1));
    expect(components.single.componentId, component.id);
    expect(components.single.imagePaths, hasLength(1));
    expect(components.single.imagePaths.single, endsWith('bearing.png'));
  });

  test('starts draft, resolves checklist bindings, and resumes existing draft', () async {
    final fixture = await _seedInspectionFixture(
      objectsRepository: objectsRepository,
      componentsRepository: componentsRepository,
      checklistsRepository: checklistsRepository,
    );

    final firstDraft = await inspectionsRepository.startOrResumeDraft(
      InspectionStartRequest(
        userId: 'user-default-admin',
        productObjectId: fixture.productId,
        targetObjectId: fixture.machineId,
      ),
    );

    expect(firstDraft.items, hasLength(3));
    expect(
      firstDraft.items.map((item) => item.title),
      containsAll(<String>[
        'Inspect product passport',
        'Inspect machine body',
        'Check bearing clearance',
      ]),
    );

    final resumedDraft = await inspectionsRepository.startOrResumeDraft(
      InspectionStartRequest(
        userId: 'user-default-admin',
        productObjectId: fixture.productId,
        targetObjectId: fixture.machineId,
      ),
    );

    expect(resumedDraft.inspection.id, firstDraft.inspection.id);

    final allInspections = await database.select(database.inspections).get();
    expect(allInspections, hasLength(1));
  });

  test('saves answers and reflects progress in draft summaries and diagnostics', () async {
    final fixture = await _seedInspectionFixture(
      objectsRepository: objectsRepository,
      componentsRepository: componentsRepository,
      checklistsRepository: checklistsRepository,
    );

    final draft = await inspectionsRepository.startOrResumeDraft(
      InspectionStartRequest(
        userId: 'user-default-admin',
        productObjectId: fixture.productId,
        targetObjectId: fixture.machineId,
      ),
    );

    final textItem = draft.items.firstWhere((item) => item.resultType == 'text');
    await inspectionsRepository.saveItemAnswer(
      inspectionId: draft.inspection.id,
      answerId: textItem.answerId,
      resultStatus: 'pass',
      comment: 'Serial confirmed',
    );

    final updatedDraft = await inspectionsRepository.loadInspection(draft.inspection.id);
    expect(updatedDraft, isNotNull);
    expect(updatedDraft!.inspection.status, 'in_progress');
    expect(
      updatedDraft.items.firstWhere((item) => item.answerId == textItem.answerId).comment,
      'Serial confirmed',
    );

    final summaries = await inspectionsRepository.listDrafts(
      userId: 'user-default-admin',
    );
    expect(summaries.single.answeredItems, 1);
    expect(summaries.single.totalItems, 3);

    final diagnostics = await inspectionsRepository.loadDiagnostics();
    expect(diagnostics.localDraftCount, 1);
  });

  test('saves signatures, generates pdf, queues completed inspection, and locks editing',
      () async {
    final fixture = await _seedInspectionFixture(
      objectsRepository: objectsRepository,
      componentsRepository: componentsRepository,
      checklistsRepository: checklistsRepository,
    );

    final draft = await inspectionsRepository.startOrResumeDraft(
      InspectionStartRequest(
        userId: 'user-default-admin',
        productObjectId: fixture.productId,
        targetObjectId: fixture.machineId,
      ),
    );

    for (final item in draft.items) {
      await inspectionsRepository.saveItemAnswer(
        inspectionId: draft.inspection.id,
        answerId: item.answerId,
        resultStatus: item.resultType == 'number' ? 'pass' : 'pass',
        comment: item.resultType == 'text' ? 'done' : null,
        measuredValue: item.resultType == 'number' ? '0.15' : null,
      );
    }

    final signature = await inspectionsRepository.saveSignature(
      inspectionId: draft.inspection.id,
      input: const InspectionSignatureInput(
        signerUserId: 'user-default-admin',
        signerName: 'Default Administrator',
        signerRole: 'Administrator',
        imageBytes: <int>[137, 80, 78, 71, 13, 10, 26, 10],
      ),
    );
    expect(File(signature.imageAbsolutePath).existsSync(), isTrue);

    final pdfInfo = await inspectionsRepository.generatePdf(draft.inspection.id);
    expect(File(pdfInfo.absolutePath).existsSync(), isTrue);

    final completion = await inspectionsRepository.completeInspection(
      inspectionId: draft.inspection.id,
      actorUserId: 'user-default-admin',
    );
    expect(completion.status, 'queued');
    expect(completion.syncStatus, 'queued');
    expect(completion.queueRecordId, isNotEmpty);

    final queue = await database.select(database.syncQueue).get();
    expect(queue, hasLength(1));
    expect(queue.single.packageType, 'inspection_result');
    expect(queue.single.packageId, draft.inspection.id);
    expect(
      Directory(paths.resolveRelativePath(queue.single.localPath)).existsSync(),
      isTrue,
    );

    final results = await inspectionsRepository.listResults(
      userId: 'user-default-admin',
    );
    expect(results.single.hasPdf, isTrue);
    expect(results.single.signatureCount, 1);

    await expectLater(
      () => inspectionsRepository.saveItemAnswer(
        inspectionId: draft.inspection.id,
        answerId: draft.items.first.answerId,
        resultStatus: 'fail',
      ),
      throwsA(isA<StateError>()),
    );

    final diagnostics = await inspectionsRepository.loadDiagnostics();
    expect(diagnostics.queuedResultCount, 1);
  });
}

class _InspectionFixture {
  const _InspectionFixture({
    required this.productId,
    required this.machineId,
    required this.componentId,
  });

  final String productId;
  final String machineId;
  final String componentId;
}

Future<_InspectionFixture> _seedInspectionFixture({
  required ObjectsRepository objectsRepository,
  required ComponentsRepository componentsRepository,
  required ChecklistsRepository checklistsRepository,
}) async {
  await objectsRepository.saveObject(
    type: 'product',
    name: 'Pump A',
    sortOrder: 1,
    isActive: true,
  );
  final product = (await objectsRepository.listActiveObjects()).single;

  await objectsRepository.saveObject(
    type: 'machine',
    parentId: product.id,
    name: 'Pump housing',
    sortOrder: 2,
    isActive: true,
  );
  final machine = (await objectsRepository.listActiveObjects())
      .firstWhere((item) => item.parentId == product.id);

  await componentsRepository.saveComponent(
    objectId: machine.id,
    name: 'Bearing',
    sortOrder: 1,
    isRequired: true,
  );
  final component = (await componentsRepository.listByObject(machine.id)).single;

  final productChecklistId = await checklistsRepository.saveChecklist(
    name: 'Product intake',
    isActive: true,
  );
  await checklistsRepository.saveChecklistItem(
    checklistId: productChecklistId,
    title: 'Inspect product passport',
    resultType: 'text',
    isRequired: true,
    sortOrder: 1,
  );
  await checklistsRepository.saveChecklistBinding(
    checklistId: productChecklistId,
    targetType: 'product',
    targetId: product.id,
    priority: 30,
    isRequired: true,
  );

  final typeChecklistId = await checklistsRepository.saveChecklist(
    name: 'Machine body',
    isActive: true,
  );
  await checklistsRepository.saveChecklistItem(
    checklistId: typeChecklistId,
    title: 'Inspect machine body',
    resultType: 'pass_fail',
    isRequired: true,
    sortOrder: 1,
  );
  await checklistsRepository.saveChecklistBinding(
    checklistId: typeChecklistId,
    targetType: 'object_type',
    targetObjectType: 'machine',
    priority: 20,
    isRequired: true,
  );

  final objectChecklistId = await checklistsRepository.saveChecklist(
    name: 'Bearing checks',
    isActive: true,
  );
  await checklistsRepository.saveChecklistItem(
    checklistId: objectChecklistId,
    componentId: component.id,
    title: 'Check bearing clearance',
    resultType: 'number',
    isRequired: true,
    sortOrder: 1,
  );
  await checklistsRepository.saveChecklistBinding(
    checklistId: objectChecklistId,
    targetType: 'object',
    targetId: machine.id,
    priority: 10,
    isRequired: true,
  );

  return _InspectionFixture(
    productId: product.id,
    machineId: machine.id,
    componentId: component.id,
  );
}
