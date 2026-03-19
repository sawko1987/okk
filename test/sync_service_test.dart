import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/core/logging/app_logger.dart';
import 'package:okk_qc_app/core/platform/app_platform.dart';
import 'package:okk_qc_app/core/storage/app_paths.dart';
import 'package:okk_qc_app/data/sqlite/app_database.dart';
import 'package:okk_qc_app/data/sync/package_archive.dart';
import 'package:okk_qc_app/data/sync/sync_service.dart';
import 'package:okk_qc_app/data/sync/yandex_disk_transport.dart';
import 'package:okk_qc_app/features/admin/data/admin_repositories.dart';
import 'package:okk_qc_app/features/catalog/data/master_data_repositories.dart';
import 'package:okk_qc_app/features/inspections/data/inspection_repositories.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tempRoot;
  late Directory remoteRoot;
  late AppDatabase windowsDb;
  late AppDatabase androidDb;
  late AppPaths windowsPaths;
  late AppPaths androidPaths;
  late SyncService windowsSyncService;
  late SyncService androidSyncService;
  late InspectionsRepository androidInspectionsRepository;
  late ObjectsRepository windowsObjectsRepository;
  late ComponentsRepository windowsComponentsRepository;
  late ChecklistsRepository windowsChecklistsRepository;

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    tempRoot = await Directory.systemTemp.createTemp('okk-sync-test-');
    remoteRoot = Directory(p.join(tempRoot.path, 'remote'));
    await remoteRoot.create(recursive: true);

    windowsPaths = AppPaths.forTesting(p.join(tempRoot.path, 'windows_app_data'));
    androidPaths = AppPaths.forTesting(p.join(tempRoot.path, 'android_app_data'));
    await windowsPaths.ensureCreated();
    await androidPaths.ensureCreated();

    windowsDb = AppDatabase.forTesting(NativeDatabase.memory());
    androidDb = AppDatabase.forTesting(NativeDatabase.memory());

    await windowsDb.ensureBootstrapData(
      deviceId: 'windows-device-1',
      deviceName: 'windows-test',
      platform: 'windows',
      appVersion: '1.0.0+1',
      rootPath: windowsPaths.rootDir.path,
    );
    await androidDb.ensureBootstrapData(
      deviceId: 'android-device-1',
      deviceName: 'android-test',
      platform: 'android',
      appVersion: '1.0.0+1',
      rootPath: androidPaths.rootDir.path,
    );

    final transport = _FakeSyncTransport(remoteRoot);
    windowsObjectsRepository = ObjectsRepository(windowsDb);
    windowsComponentsRepository = ComponentsRepository(windowsDb);
    windowsChecklistsRepository = ChecklistsRepository(windowsDb);
    androidInspectionsRepository = InspectionsRepository(androidDb, androidPaths);

    windowsSyncService = SyncService(
      db: windowsDb,
      paths: windowsPaths,
      logger: AppLogger(),
      transport: transport,
      packageArchive: PackageArchive(),
      referencePackageRepository: ReferencePackageRepository(windowsDb, windowsPaths),
      inspectionsRepository: InspectionsRepository(windowsDb, windowsPaths),
    );
    androidSyncService = SyncService(
      db: androidDb,
      paths: androidPaths,
      logger: AppLogger(),
      transport: transport,
      packageArchive: PackageArchive(),
      referencePackageRepository: ReferencePackageRepository(androidDb, androidPaths),
      inspectionsRepository: androidInspectionsRepository,
    );
  });

  tearDown(() async {
    await windowsDb.close();
    await androidDb.close();
    if (await tempRoot.exists()) {
      await tempRoot.delete(recursive: true);
    }
  });

  test('publishes reference, syncs android, uploads result, and imports it on windows',
      () async {
    final fixture = await _seedInspectionFixture(
      objectsRepository: windowsObjectsRepository,
      componentsRepository: windowsComponentsRepository,
      checklistsRepository: windowsChecklistsRepository,
    );

    final publishResult = await windowsSyncService.publishReferencePackage(
      actorUserId: 'user-default-admin',
    );
    expect(publishResult.packageId, isNotEmpty);

    await androidSyncService.runManualSync(
      platform: AppPlatform.android,
      actorUserId: 'user-default-admin',
    );

    final androidObjects = await androidDb.select(androidDb.catalogObjects).get();
    expect(
      androidObjects.any((object) => object.id == fixture.productId),
      isTrue,
    );

    final draft = await androidSyncService.startInspectionDraft(
      request: InspectionStartRequest(
        userId: 'user-default-admin',
        productObjectId: fixture.productId,
        targetObjectId: fixture.machineId,
      ),
    );
    expect(draft.items, isNotEmpty);

    for (final item in draft.items) {
      await androidInspectionsRepository.saveItemAnswer(
        inspectionId: draft.inspection.id,
        answerId: item.answerId,
        resultStatus: item.resultType == 'number' ? 'pass' : 'pass',
        comment: item.resultType == 'text' ? 'done' : null,
        measuredValue: item.resultType == 'number' ? '0.15' : null,
      );
    }
    await androidInspectionsRepository.saveSignature(
      inspectionId: draft.inspection.id,
      input: const InspectionSignatureInput(
        signerUserId: 'user-default-admin',
        signerName: 'Default Administrator',
        signerRole: 'Administrator',
        imageBytes: <int>[137, 80, 78, 71, 13, 10, 26, 10],
      ),
    );
    await androidSyncService.completeInspection(
      inspectionId: draft.inspection.id,
      actorUserId: 'user-default-admin',
    );

    await androidSyncService.runManualSync(
      platform: AppPlatform.android,
      actorUserId: 'user-default-admin',
    );
    await windowsSyncService.runManualSync(
      platform: AppPlatform.windows,
      actorUserId: 'user-default-admin',
    );

    final importedInspection = await (windowsDb.select(windowsDb.inspections)
          ..where((tbl) => tbl.id.equals(draft.inspection.id)))
        .getSingle();
    expect(importedInspection.status, 'synced');
    expect(importedInspection.syncStatus, 'imported');

    final importedItems = await (windowsDb.select(windowsDb.inspectionItems)
          ..where((tbl) => tbl.inspectionId.equals(draft.inspection.id)))
        .get();
    expect(importedItems, hasLength(draft.items.length));

    final incomingQueue = await (windowsDb.select(windowsDb.syncQueue)
          ..where((tbl) => tbl.direction.equals('incoming')))
        .get();
    expect(incomingQueue.single.status, 'done');
  });

  test('best-effort sync pushes queued result right after completion on android',
      () async {
    final fixture = await _seedInspectionFixture(
      objectsRepository: windowsObjectsRepository,
      componentsRepository: windowsComponentsRepository,
      checklistsRepository: windowsChecklistsRepository,
    );

    await windowsSyncService.publishReferencePackage(
      actorUserId: 'user-default-admin',
    );
    await androidSyncService.runManualSync(
      platform: AppPlatform.android,
      actorUserId: 'user-default-admin',
    );

    final draft = await androidSyncService.startInspectionDraft(
      request: InspectionStartRequest(
        userId: 'user-default-admin',
        productObjectId: fixture.productId,
        targetObjectId: fixture.machineId,
      ),
    );
    for (final item in draft.items) {
      await androidInspectionsRepository.saveItemAnswer(
        inspectionId: draft.inspection.id,
        answerId: item.answerId,
        resultStatus: 'pass',
      );
    }
    await androidInspectionsRepository.saveSignature(
      inspectionId: draft.inspection.id,
      input: const InspectionSignatureInput(
        signerUserId: 'user-default-admin',
        signerName: 'Default Administrator',
        signerRole: 'Administrator',
        imageBytes: <int>[137, 80, 78, 71, 13, 10, 26, 10],
      ),
    );

    await androidSyncService.completeInspection(
      inspectionId: draft.inspection.id,
      actorUserId: 'user-default-admin',
    );

    final queuedEntry = await (androidDb.select(androidDb.syncQueue)
          ..where((tbl) => tbl.packageId.equals(draft.inspection.id)))
        .getSingle();
    final inspection = await (androidDb.select(androidDb.inspections)
          ..where((tbl) => tbl.id.equals(draft.inspection.id)))
        .getSingle();

    expect(queuedEntry.status, 'done');
    expect(inspection.syncStatus, 'uploaded');
    expect(
      File(
        p.join(
          remoteRoot.path,
          'results',
          'incoming',
          'result_${draft.inspection.id}.zip',
        ),
      ).existsSync(),
      isTrue,
    );
  });

  test('windows sync continues importing valid packages when one package is broken',
      () async {
    final fixture = await _seedInspectionFixture(
      objectsRepository: windowsObjectsRepository,
      componentsRepository: windowsComponentsRepository,
      checklistsRepository: windowsChecklistsRepository,
    );

    await windowsSyncService.publishReferencePackage(
      actorUserId: 'user-default-admin',
    );
    await androidSyncService.runManualSync(
      platform: AppPlatform.android,
      actorUserId: 'user-default-admin',
    );

    final draft = await androidSyncService.startInspectionDraft(
      request: InspectionStartRequest(
        userId: 'user-default-admin',
        productObjectId: fixture.productId,
        targetObjectId: fixture.machineId,
      ),
    );
    for (final item in draft.items) {
      await androidInspectionsRepository.saveItemAnswer(
        inspectionId: draft.inspection.id,
        answerId: item.answerId,
        resultStatus: 'pass',
      );
    }
    await androidInspectionsRepository.saveSignature(
      inspectionId: draft.inspection.id,
      input: const InspectionSignatureInput(
        signerUserId: 'user-default-admin',
        signerName: 'Default Administrator',
        signerRole: 'Administrator',
        imageBytes: <int>[137, 80, 78, 71, 13, 10, 26, 10],
      ),
    );
    await androidSyncService.completeInspection(
      inspectionId: draft.inspection.id,
      actorUserId: 'user-default-admin',
    );

    final brokenPackage = File(
      p.join(remoteRoot.path, 'results', 'incoming', 'result_broken_pkg.zip'),
    );
    await brokenPackage.parent.create(recursive: true);
    await brokenPackage.writeAsString('not-a-zip');

    final report = await windowsSyncService.runManualSync(
      platform: AppPlatform.windows,
      actorUserId: 'user-default-admin',
    );

    final importedInspection = await (windowsDb.select(windowsDb.inspections)
          ..where((tbl) => tbl.id.equals(draft.inspection.id)))
        .getSingle();
    final failedIncomingQueue = await (windowsDb.select(windowsDb.syncQueue)
          ..where((tbl) => tbl.packageId.equals('broken_pkg')))
        .getSingle();

    expect(importedInspection.syncStatus, 'imported');
    expect(report.failureCount, 1);
    expect(report.resultImportedCount, 1);
    expect(failedIncomingQueue.status, 'failed');
  });

  test('windows marks duplicate result package import as conflict', () async {
    final fixture = await _seedInspectionFixture(
      objectsRepository: windowsObjectsRepository,
      componentsRepository: windowsComponentsRepository,
      checklistsRepository: windowsChecklistsRepository,
    );

    await windowsSyncService.publishReferencePackage(
      actorUserId: 'user-default-admin',
    );
    await androidSyncService.runManualSync(
      platform: AppPlatform.android,
      actorUserId: 'user-default-admin',
    );

    final draft = await androidSyncService.startInspectionDraft(
      request: InspectionStartRequest(
        userId: 'user-default-admin',
        productObjectId: fixture.productId,
        targetObjectId: fixture.machineId,
      ),
    );
    for (final item in draft.items) {
      await androidInspectionsRepository.saveItemAnswer(
        inspectionId: draft.inspection.id,
        answerId: item.answerId,
        resultStatus: 'pass',
      );
    }
    await androidInspectionsRepository.saveSignature(
      inspectionId: draft.inspection.id,
      input: const InspectionSignatureInput(
        signerUserId: 'user-default-admin',
        signerName: 'Default Administrator',
        signerRole: 'Administrator',
        imageBytes: <int>[137, 80, 78, 71, 13, 10, 26, 10],
      ),
    );
    await androidSyncService.completeInspection(
      inspectionId: draft.inspection.id,
      actorUserId: 'user-default-admin',
    );

    await windowsSyncService.runManualSync(
      platform: AppPlatform.windows,
      actorUserId: 'user-default-admin',
    );

    final processedFile = File(
      p.join(
        remoteRoot.path,
        'results',
        'processed',
        'result_${draft.inspection.id}.zip',
      ),
    );
    final duplicateIncoming = File(
      p.join(
        remoteRoot.path,
        'results',
        'incoming',
        'result_${draft.inspection.id}.zip',
      ),
    );
    await duplicateIncoming.parent.create(recursive: true);
    await processedFile.copy(duplicateIncoming.path);

    final report = await windowsSyncService.runManualSync(
      platform: AppPlatform.windows,
      actorUserId: 'user-default-admin',
    );
    final conflictInspection = await (windowsDb.select(windowsDb.inspections)
          ..where((tbl) => tbl.id.equals(draft.inspection.id)))
        .getSingle();

    expect(report.conflictCount, 1);
    expect(
      File(
        p.join(
          remoteRoot.path,
          'results',
          'conflicts',
          'result_${draft.inspection.id}.zip',
        ),
      ).existsSync(),
      isTrue,
    );
    expect(conflictInspection.syncStatus, 'imported');
  });
}

class _InspectionFixture {
  const _InspectionFixture({
    required this.productId,
    required this.machineId,
  });

  final String productId;
  final String machineId;
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
  );
}

class _FakeSyncTransport implements SyncTransport {
  _FakeSyncTransport(this._rootDirectory);

  final Directory _rootDirectory;

  @override
  Future<void> deletePath(String remotePath) async {
    final entity = FileSystemEntity.typeSync(_resolve(remotePath));
    if (entity == FileSystemEntityType.notFound) {
      return;
    }
    if (entity == FileSystemEntityType.directory) {
      await Directory(_resolve(remotePath)).delete(recursive: true);
      return;
    }
    await File(_resolve(remotePath)).delete();
  }

  @override
  Future<File> downloadFile({
    required String remotePath,
    required File destinationFile,
  }) async {
    final source = File(_resolve(remotePath));
    if (!await source.exists()) {
      throw StateError('Remote file does not exist: $remotePath');
    }
    await destinationFile.parent.create(recursive: true);
    await source.copy(destinationFile.path);
    return destinationFile;
  }

  @override
  Future<String?> downloadString(String remotePath) async {
    final file = File(_resolve(remotePath));
    if (!await file.exists()) {
      return null;
    }
    return file.readAsString();
  }

  @override
  Future<void> ensureRemoteLayout() async {
    for (final relativePath in [
      '',
      'manifest',
      'reference_data/packages',
      'results/incoming',
      'results/processed',
      'results/conflicts',
      'media/components',
      'locks',
    ]) {
      await Directory(_resolve(relativePath)).create(recursive: true);
    }
  }

  @override
  Future<bool> isConfigured() async => true;

  @override
  Future<List<RemoteEntry>> listFiles(String remoteDirectory) async {
    final directory = Directory(_resolve(remoteDirectory));
    if (!await directory.exists()) {
      return const [];
    }
    final entries = await directory.list().toList();
    return entries
        .map(
          (entry) => RemoteEntry(
            name: p.basename(entry.path),
            path: entry.path,
            type: entry is Directory ? 'dir' : 'file',
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> uploadFile({
    required String remotePath,
    required File file,
    String? contentType,
  }) async {
    final destination = File(_resolve(remotePath));
    await destination.parent.create(recursive: true);
    await file.copy(destination.path);
  }

  @override
  Future<void> uploadString({
    required String remotePath,
    required String content,
    String contentType = 'application/json; charset=utf-8',
  }) async {
    final destination = File(_resolve(remotePath));
    await destination.parent.create(recursive: true);
    await destination.writeAsString(content);
  }

  String _resolve(String remotePath) {
    final normalized = remotePath.replaceAll('/', Platform.pathSeparator);
    return p.join(_rootDirectory.path, normalized);
  }
}
