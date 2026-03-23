import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../app/bootstrap/bootstrap_data.dart';
import '../../../core/auth/app_permissions.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/storage/app_paths.dart';
import '../../../core/utils/checksum.dart';
import '../../../data/sqlite/app_database.dart';
import '../../../data/sqlite/database_provider.dart';
import '../../../data/sqlite/repository_support.dart';
import '../../../data/storage/app_paths_provider.dart';
import '../../../data/sync/package_archive.dart';

const _backupManifestName = 'backup_manifest.json';

String _normalizeManifestPath(String path) => path.replaceAll('\\', '/');

class BackupArchiveSummary {
  const BackupArchiveSummary({
    required this.archivePath,
    required this.archiveSizeBytes,
    required this.backupId,
    required this.createdAt,
    required this.appVersion,
    required this.dbSchemaVersion,
    required this.syncSchemaVersion,
    required this.fileCount,
    required this.includedRoots,
    required this.deviceId,
    required this.deviceName,
    required this.hasDatabaseSnapshot,
    required this.restoreIssues,
    required this.inspectionError,
  });

  final String archivePath;
  final int archiveSizeBytes;
  final String backupId;
  final String? createdAt;
  final String? appVersion;
  final int? dbSchemaVersion;
  final String? syncSchemaVersion;
  final int fileCount;
  final List<String> includedRoots;
  final String? deviceId;
  final String? deviceName;
  final bool hasDatabaseSnapshot;
  final List<String> restoreIssues;
  final String? inspectionError;

  String get archiveName => p.basename(archivePath);
  bool get isInspectable => inspectionError == null;
  bool get isSchemaCompatible =>
      dbSchemaVersion == AppConstants.appSchemaVersion &&
      syncSchemaVersion == AppConstants.syncSchemaVersion;
  bool get isRestorable =>
      isInspectable &&
      isSchemaCompatible &&
      hasDatabaseSnapshot &&
      restoreIssues.isEmpty;
}

class BackupRestoreResult {
  const BackupRestoreResult({
    required this.backupId,
    required this.restoredRootPath,
    required this.previousRootPath,
    required this.requiresRestart,
  });

  final String backupId;
  final String restoredRootPath;
  final String previousRootPath;
  final bool requiresRestart;
}

class BackupRepository {
  BackupRepository({
    required AppDatabase database,
    required AppPaths paths,
    required PackageArchive archive,
    required AppLogger logger,
  }) : _db = database,
       _paths = paths,
       _archive = archive,
       _logger = logger;

  final AppDatabase _db;
  final AppPaths _paths;
  final PackageArchive _archive;
  final AppLogger _logger;

  Future<BackupArchiveSummary> createBackup({String? actorUserId}) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageSync,
      deniedMessage: 'Только администратор может создавать резервные копии.',
    );

    final backupId = generateId('backup');
    final createdAt = nowIso();
    final stagingRoot = await Directory.systemTemp.createTemp(
      'okk_backup_$backupId',
    );
    final snapshotDir = Directory(p.join(stagingRoot.path, 'snapshot'));
    final files = <Map<String, Object?>>[];
    final includedRoots = <String>[];

    try {
      await snapshotDir.create(recursive: true);

      final device = await _db.select(_db.deviceInfo).getSingleOrNull();
      await _exportDatabaseSnapshot(
        snapshotDir: snapshotDir,
        fileEntries: files,
        includedRoots: includedRoots,
      );
      await _copyDirectoryIfExists(
        source: _paths.mediaDir,
        relativeRoot: 'media',
        snapshotDir: snapshotDir,
        fileEntries: files,
        includedRoots: includedRoots,
      );
      await _copyDirectoryIfExists(
        source: _paths.logsDir,
        relativeRoot: 'logs',
        snapshotDir: snapshotDir,
        fileEntries: files,
        includedRoots: includedRoots,
      );

      for (final syncRoot in <MapEntry<Directory, String>>[
        MapEntry(_paths.syncIncomingDir, p.join('sync', 'incoming')),
        MapEntry(_paths.syncOutgoingDir, p.join('sync', 'outgoing')),
        MapEntry(_paths.syncProcessedDir, p.join('sync', 'processed')),
      ]) {
        await _copyDirectoryIfExists(
          source: syncRoot.key,
          relativeRoot: syncRoot.value,
          snapshotDir: snapshotDir,
          fileEntries: files,
          includedRoots: includedRoots,
        );
      }

      final manifest = <String, Object?>{
        'format': 'okk_backup_v1',
        'backup_id': backupId,
        'created_at': createdAt,
        'app_version': AppConstants.appVersion,
        'db_schema_version': AppConstants.appSchemaVersion,
        'sync_schema_version': AppConstants.syncSchemaVersion,
        'actor_user_id': actorUserId,
        'device': {
          'id': device?.id ?? AppConstants.defaultDeviceId,
          'name': device?.deviceName ?? 'unknown-device',
          'platform': device?.platform ?? Platform.operatingSystem,
          'root_path': _paths.rootDir.path,
        },
        'included_roots': includedRoots,
        'file_count': files.length,
        'files': files,
      };

      final manifestFile = File(p.join(snapshotDir.path, _backupManifestName));
      await manifestFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(manifest),
      );

      final archiveFile = File(
        p.join(_paths.backupDir.path, 'backup_$backupId.zip'),
      );
      await _archive.zipDirectory(
        sourceDirectory: snapshotDir,
        destinationFile: archiveFile,
      );

      final summary = await inspectBackupArchive(archiveFile);
      await recordAudit(
        _db,
        actionType: 'backup.create',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'backup',
        entityId: backupId,
        message: 'Резервная копия создана',
        payload: {'archive_path': archiveFile.path, 'file_count': files.length},
      );
      _logger.info('Backup archive created at ${archiveFile.path}');
      return summary;
    } catch (error, stackTrace) {
      _logger.error('Backup archive creation failed.', error, stackTrace);
      try {
        await recordAudit(
          _db,
          actionType: 'backup.create',
          resultStatus: 'error',
          userId: actorUserId,
          entityType: 'backup',
          entityId: backupId,
          message: 'Не удалось создать резервную копию',
          payload: {'error': error.toString()},
        );
      } catch (_) {
        // Ignore audit write failures during backup error handling.
      }
      rethrow;
    } finally {
      if (await stagingRoot.exists()) {
        await stagingRoot.delete(recursive: true);
      }
    }
  }

  Future<List<BackupArchiveSummary>> listBackups() async {
    await _paths.backupDir.create(recursive: true);
    final entities = await _paths.backupDir.list().toList();
    final files =
        entities
            .whereType<File>()
            .where((file) => file.path.toLowerCase().endsWith('.zip'))
            .toList(growable: false)
          ..sort((a, b) => b.path.compareTo(a.path));

    final results = <BackupArchiveSummary>[];
    for (final file in files) {
      results.add(await inspectBackupArchive(file));
    }
    return results;
  }

  Future<BackupArchiveSummary> inspectRestoreCandidate(File archiveFile) {
    return inspectBackupArchive(archiveFile);
  }

  Future<BackupRestoreResult> restoreBackup({
    required File archiveFile,
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageSync,
      deniedMessage:
          'Только администратор может восстанавливать резервные копии.',
    );

    final candidate = await inspectRestoreCandidate(archiveFile);
    if (!candidate.isRestorable) {
      final issueText =
          candidate.inspectionError ??
          (candidate.restoreIssues.isEmpty
              ? 'Архив не готов к восстановлению.'
              : candidate.restoreIssues.join(' '));
      throw StateError(issueText);
    }

    final restoreId = generateId('restore');
    final stagingRoot = await Directory.systemTemp.createTemp(
      'okk_restore_$restoreId',
    );
    final extractedDir = Directory(p.join(stagingRoot.path, 'extracted'));
    final currentRoot = _paths.rootDir;
    final previousRoot = Directory(
      p.join(currentRoot.parent.path, 'app_data_before_restore_$restoreId'),
    );

    var currentRootMoved = false;
    var restoredRootMoved = false;
    try {
      await _archive.unzipFile(
        sourceFile: archiveFile,
        destinationDirectory: extractedDir,
      );
      await _validateExtractedDirectory(extractedDir);

      await _logger.dispose();
      await _db.close();

      if (await previousRoot.exists()) {
        await previousRoot.delete(recursive: true);
      }

      if (await currentRoot.exists()) {
        await currentRoot.rename(previousRoot.path);
        currentRootMoved = true;
      }

      await extractedDir.rename(currentRoot.path);
      restoredRootMoved = true;

      final restoredDatabase = AppDatabase.connect(
        File(p.join(currentRoot.path, 'db', 'main.db')),
      );
      try {
        await recordAudit(
          restoredDatabase,
          actionType: 'backup.restore',
          resultStatus: 'success',
          userId: actorUserId,
          entityType: 'backup',
          entityId: candidate.backupId,
          message: 'Выполнено восстановление из резервной копии',
          payload: {
            'archive_path': archiveFile.path,
            'previous_root_path': previousRoot.path,
          },
        );
      } finally {
        await restoredDatabase.close();
      }

      return BackupRestoreResult(
        backupId: candidate.backupId,
        restoredRootPath: currentRoot.path,
        previousRootPath: previousRoot.path,
        requiresRestart: true,
      );
    } catch (error) {
      if (currentRootMoved && !restoredRootMoved) {
        if (await currentRoot.exists()) {
          await currentRoot.delete(recursive: true);
        }
        if (await previousRoot.exists()) {
          await previousRoot.rename(currentRoot.path);
        }
      }
      rethrow;
    } finally {
      if (await stagingRoot.exists()) {
        await stagingRoot.delete(recursive: true);
      }
    }
  }

  Future<BackupArchiveSummary> inspectBackupArchive(File archiveFile) async {
    final archiveSizeBytes = await archiveFile.length();
    try {
      final input = InputFileStream(archiveFile.path);
      try {
        final archive = ZipDecoder().decodeBuffer(input);
        final manifestEntry = archive.files.firstWhere(
          (entry) => entry.name == _backupManifestName,
          orElse: () =>
              throw StateError('Архив не содержит $_backupManifestName.'),
        );
        final rawManifest = utf8.decode(manifestEntry.content as List<int>);
        final manifest = jsonDecode(rawManifest) as Map<String, Object?>;
        final device = manifest['device'] as Map<String, Object?>? ?? const {};
        final includedRoots =
            (manifest['included_roots'] as List<Object?>? ?? const [])
                .whereType<String>()
                .map(_normalizeManifestPath)
                .toList(growable: false);
        final fileEntries = (manifest['files'] as List<Object?>? ?? const [])
            .map<Map<String, Object?>?>((entry) {
              if (entry is! Map) {
                return null;
              }
              return {
                for (final mapEntry in entry.entries)
                  mapEntry.key.toString(): mapEntry.value,
              };
            })
            .whereType<Map<String, Object?>>()
            .toList(growable: false);
        final fileCount = manifest['file_count'] is int
            ? manifest['file_count'] as int
            : fileEntries.length;
        final hasDatabaseSnapshot = fileEntries.any(
          (entry) =>
              _normalizeManifestPath(
                entry['relative_path']?.toString() ?? '',
              ) ==
              'db/main.db',
        );
        final restoreIssues = <String>[
          if (!hasDatabaseSnapshot)
            'В архиве отсутствует снимок базы данных db/main.db.',
          if (!includedRoots.contains('db'))
            'В manifest отсутствует обязательный корневой раздел db.',
          if (manifest['format'] != 'okk_backup_v1')
            'Неподдерживаемый формат резервной копии.',
          if (manifest['db_schema_version'] != AppConstants.appSchemaVersion)
            'Версия схемы БД не совпадает с текущей сборкой.',
          if (manifest['sync_schema_version'] != AppConstants.syncSchemaVersion)
            'Версия схемы синхронизации не совпадает с текущей сборкой.',
        ];

        return BackupArchiveSummary(
          archivePath: archiveFile.path,
          archiveSizeBytes: archiveSizeBytes,
          backupId:
              (manifest['backup_id'] as String?) ??
              p.basenameWithoutExtension(archiveFile.path),
          createdAt: manifest['created_at'] as String?,
          appVersion: manifest['app_version'] as String?,
          dbSchemaVersion: manifest['db_schema_version'] as int?,
          syncSchemaVersion: manifest['sync_schema_version'] as String?,
          fileCount: fileCount,
          includedRoots: includedRoots,
          deviceId: device['id'] as String?,
          deviceName: device['name'] as String?,
          hasDatabaseSnapshot: hasDatabaseSnapshot,
          restoreIssues: restoreIssues,
          inspectionError: null,
        );
      } finally {
        input.close();
      }
    } catch (error) {
      return BackupArchiveSummary(
        archivePath: archiveFile.path,
        archiveSizeBytes: archiveSizeBytes,
        backupId: p.basenameWithoutExtension(archiveFile.path),
        createdAt: null,
        appVersion: null,
        dbSchemaVersion: null,
        syncSchemaVersion: null,
        fileCount: 0,
        includedRoots: const [],
        deviceId: null,
        deviceName: null,
        hasDatabaseSnapshot: false,
        restoreIssues: const [],
        inspectionError: error.toString(),
      );
    }
  }

  Future<void> _exportDatabaseSnapshot({
    required Directory snapshotDir,
    required List<Map<String, Object?>> fileEntries,
    required List<String> includedRoots,
  }) async {
    final relativePath = 'db/main.db';
    final destinationFile = File(p.join(snapshotDir.path, relativePath));
    await destinationFile.parent.create(recursive: true);
    if (await destinationFile.exists()) {
      await destinationFile.delete();
    }

    final escapedPath = destinationFile.path
        .replaceAll('\\', '/')
        .replaceAll("'", "''");
    await _db.customStatement("VACUUM INTO '$escapedPath';");
    includedRoots.add('db');
    fileEntries.add(await _buildFileEntry(destinationFile, relativePath));
  }

  Future<void> _copyDirectoryIfExists({
    required Directory source,
    required String relativeRoot,
    required Directory snapshotDir,
    required List<Map<String, Object?>> fileEntries,
    required List<String> includedRoots,
  }) async {
    if (!await source.exists()) {
      return;
    }

    var copiedAnyFile = false;
    await for (final entity in source.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is! File) {
        continue;
      }
      copiedAnyFile = true;
      final relativePath = _normalizeManifestPath(
        p.join(relativeRoot, p.relative(entity.path, from: source.path)),
      );
      final destination = File(p.join(snapshotDir.path, relativePath));
      await destination.parent.create(recursive: true);
      await entity.copy(destination.path);
      fileEntries.add(await _buildFileEntry(destination, relativePath));
    }

    if (copiedAnyFile) {
      includedRoots.add(_normalizeManifestPath(relativeRoot));
    }
  }

  Future<Map<String, Object?>> _buildFileEntry(
    File file,
    String relativePath,
  ) async {
    final stat = await file.stat();
    return {
      'relative_path': relativePath,
      'size_bytes': stat.size,
      'modified_at': stat.modified.toUtc().toIso8601String(),
      'checksum': await checksumFile(file),
    };
  }

  Future<void> _validateExtractedDirectory(Directory extractedDir) async {
    final manifestFile = File(p.join(extractedDir.path, _backupManifestName));
    final databaseFile = File(p.join(extractedDir.path, 'db', 'main.db'));

    if (!await manifestFile.exists()) {
      throw StateError(
        'В распакованном архиве отсутствует $_backupManifestName.',
      );
    }
    if (!await databaseFile.exists()) {
      throw StateError('В распакованном архиве отсутствует db/main.db.');
    }
  }
}

final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => BackupRepository(
    database: ref.watch(appDatabaseProvider),
    paths: ref.watch(appPathsProvider),
    archive: ref.watch(packageArchiveProvider),
    logger: ref.watch(bootstrapDataProvider).logger,
  ),
);

final backupsProvider = FutureProvider<List<BackupArchiveSummary>>(
  (ref) => ref.watch(backupRepositoryProvider).listBackups(),
);
