import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/core/config/app_constants.dart';
import 'package:okk_qc_app/core/logging/app_logger.dart';
import 'package:okk_qc_app/core/storage/app_paths.dart';
import 'package:okk_qc_app/data/sqlite/app_database.dart';
import 'package:okk_qc_app/data/sync/package_archive.dart';
import 'package:okk_qc_app/features/admin/data/backup_repository.dart';
import 'package:path/path.dart' as p;

void main() {
  test('creates inspectable backup archive with manifest and selected roots', () async {
    final tempDir = await Directory.systemTemp.createTemp('okk_qc_backup_test_');
    addTearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    final paths = AppPaths.forTesting(p.join(tempDir.path, 'app_data'));
    await paths.ensureCreated();

    final database = AppDatabase.forTesting(NativeDatabase(paths.databaseFile));
    addTearDown(database.close);
    await database.ensureBootstrapData(
      deviceId: AppConstants.defaultDeviceId,
      deviceName: 'backup-test-device',
      platform: Platform.operatingSystem,
      appVersion: AppConstants.appVersion,
      rootPath: paths.rootDir.path,
    );

    await File(
      p.join(paths.componentsDir.path, 'component-1', 'image.txt'),
    ).create(recursive: true);
    await File(
      p.join(paths.componentsDir.path, 'component-1', 'image.txt'),
    ).writeAsString('component media');
    await File(
      p.join(paths.syncOutgoingDir.path, 'queued_result.json'),
    ).writeAsString('queued data');

    final repository = BackupRepository(
      database: database,
      paths: paths,
      archive: PackageArchive(),
      logger: AppLogger(name: 'backup-test'),
    );

    final summary = await repository.createBackup();
    final listed = await repository.listBackups();

    expect(File(summary.archivePath).existsSync(), isTrue);
    expect(summary.isInspectable, isTrue);
    expect(summary.backupId, startsWith('backup-'));
    expect(summary.dbSchemaVersion, AppConstants.appSchemaVersion);
    expect(summary.syncSchemaVersion, AppConstants.syncSchemaVersion);
    expect(summary.includedRoots, contains('db'));
    expect(summary.includedRoots, contains('media'));
    expect(summary.includedRoots, contains('sync/outgoing'));
    expect(listed, hasLength(1));
    expect(listed.single.archivePath, summary.archivePath);
  });

  test('reports inspection error for invalid archive', () async {
    final tempDir = await Directory.systemTemp.createTemp('okk_qc_backup_test_');
    addTearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    final paths = AppPaths.forTesting(p.join(tempDir.path, 'app_data'));
    await paths.ensureCreated();

    final database = AppDatabase.forTesting(NativeDatabase(paths.databaseFile));
    addTearDown(database.close);
    await database.ensureBootstrapData(
      deviceId: AppConstants.defaultDeviceId,
      deviceName: 'backup-test-device',
      platform: Platform.operatingSystem,
      appVersion: AppConstants.appVersion,
      rootPath: paths.rootDir.path,
    );

    final repository = BackupRepository(
      database: database,
      paths: paths,
      archive: PackageArchive(),
      logger: AppLogger(name: 'backup-test'),
    );

    final archiveFile = File(p.join(paths.backupDir.path, 'broken_backup.zip'));
    await archiveFile.writeAsString('not a zip archive');

    final summary = await repository.inspectBackupArchive(archiveFile);

    expect(summary.isInspectable, isFalse);
    expect(summary.inspectionError, isNotNull);
  });
}
