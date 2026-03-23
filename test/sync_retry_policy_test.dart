import 'dart:io';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/core/logging/app_logger.dart';
import 'package:okk_qc_app/core/platform/app_platform.dart';
import 'package:okk_qc_app/core/storage/app_paths.dart';
import 'package:okk_qc_app/data/sqlite/app_database.dart';
import 'package:okk_qc_app/data/sqlite/repository_support.dart';
import 'package:okk_qc_app/data/sync/package_archive.dart';
import 'package:okk_qc_app/data/sync/sync_service.dart';
import 'package:okk_qc_app/data/sync/yandex_disk_transport.dart';
import 'package:okk_qc_app/features/admin/data/admin_repositories.dart';
import 'package:okk_qc_app/features/inspections/data/inspection_repositories.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tempRoot;
  late AppPaths paths;
  late AppDatabase db;
  late SyncService syncService;

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    tempRoot = await Directory.systemTemp.createTemp('okk-sync-retry-test-');
    paths = AppPaths.forTesting(p.join(tempRoot.path, 'app_data'));
    await paths.ensureCreated();

    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.ensureBootstrapData(
      deviceId: 'windows-device-1',
      deviceName: 'windows-test',
      platform: 'windows',
      appVersion: '1.0.0+1',
      rootPath: paths.rootDir.path,
    );

    syncService = SyncService(
      db: db,
      paths: paths,
      logger: AppLogger(),
      transport: _RetryTestTransport(
        Directory(p.join(tempRoot.path, 'remote')),
      ),
      packageArchive: PackageArchive(),
      referencePackageRepository: ReferencePackageRepository(db, paths),
      inspectionsRepository: InspectionsRepository(db, paths),
    );
  });

  tearDown(() async {
    await db.close();
    if (await tempRoot.exists()) {
      await tempRoot.delete(recursive: true);
    }
  });

  test(
    'automatic retry respects next_attempt_at while manual sync forces retry',
    () async {
      await db
          .into(db.syncQueue)
          .insert(
            SyncQueueCompanion.insert(
              id: 'queue-reference-failed',
              direction: 'outgoing',
              packageType: 'reference',
              packageId: 'reference_pkg',
              localPath: 'sync/outgoing/missing_reference_pkg',
              status: 'failed',
              attemptCount: const Value(1),
              nextAttemptAt: Value(
                DateTime.now()
                    .toUtc()
                    .add(const Duration(minutes: 10))
                    .toIso8601String(),
              ),
              createdAt: nowIso(),
              updatedAt: nowIso(),
            ),
          );

      await syncService.runAutomaticRetrySync(
        platform: AppPlatform.windows,
        actorUserId: 'user-default-admin',
        trigger: 'resume',
      );

      var queueEntry = await (db.select(
        db.syncQueue,
      )..where((tbl) => tbl.id.equals('queue-reference-failed'))).getSingle();
      expect(queueEntry.attemptCount, 1);

      await syncService.runManualSync(
        platform: AppPlatform.windows,
        actorUserId: 'user-default-admin',
      );

      queueEntry = await (db.select(
        db.syncQueue,
      )..where((tbl) => tbl.id.equals('queue-reference-failed'))).getSingle();
      expect(queueEntry.attemptCount, 2);
      expect(queueEntry.status, 'failed');
      expect(queueEntry.nextAttemptAt, isNotNull);
    },
  );

  test(
    'diagnostics expose retry-eligible queue entries and last retry timestamp',
    () async {
      await db
          .into(db.syncQueue)
          .insert(
            SyncQueueCompanion.insert(
              id: 'queue-reference-due',
              direction: 'outgoing',
              packageType: 'reference',
              packageId: 'reference_due_pkg',
              localPath: 'sync/outgoing/missing_reference_due_pkg',
              status: 'failed',
              nextAttemptAt: Value(
                DateTime.now()
                    .toUtc()
                    .subtract(const Duration(minutes: 1))
                    .toIso8601String(),
              ),
              createdAt: nowIso(),
              updatedAt: nowIso(),
            ),
          );

      var diagnostics = await syncService.loadDiagnostics();
      expect(diagnostics.retryEligibleCount, 1);
      expect(diagnostics.lastRetryAt, isNull);

      await syncService.runAutomaticRetrySync(
        platform: AppPlatform.windows,
        actorUserId: 'user-default-admin',
        trigger: 'resume',
      );

      diagnostics = await syncService.loadDiagnostics();
      expect(diagnostics.lastRetryAt, isNotNull);
    },
  );
}

class _RetryTestTransport implements SyncTransport {
  _RetryTestTransport(this._rootDirectory);

  final Directory _rootDirectory;

  @override
  Future<void> deletePath(String remotePath) async {}

  @override
  Future<File> downloadFile({
    required String remotePath,
    required File destinationFile,
  }) async {
    throw StateError('No remote files configured for retry policy tests.');
  }

  @override
  Future<String?> downloadString(String remotePath) async => null;

  @override
  Future<void> ensureRemoteLayout() async {
    await _rootDirectory.create(recursive: true);
  }

  @override
  Future<bool> isConfigured() async => true;

  @override
  Future<List<RemoteEntry>> listFiles(String remoteDirectory) async => const [];

  @override
  Future<void> uploadFile({
    required String remotePath,
    required File file,
    String? contentType,
  }) async {}

  @override
  Future<void> uploadString({
    required String remotePath,
    required String content,
    String contentType = 'application/json; charset=utf-8',
  }) async {}
}
