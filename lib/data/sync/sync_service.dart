import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../app/bootstrap/bootstrap_data.dart';
import '../../core/auth/app_permissions.dart';
import '../../core/config/app_constants.dart';
import '../../core/logging/app_logger.dart';
import '../../core/platform/app_platform.dart';
import '../../core/storage/app_paths.dart';
import '../../core/utils/checksum.dart';
import '../../features/admin/data/admin_repositories.dart';
import '../../features/inspections/data/inspection_repositories.dart';
import '../sqlite/app_database.dart';
import '../sqlite/database_provider.dart';
import '../sqlite/repository_support.dart';
import '../sqlite/tables/sync_queue.dart';
import '../storage/app_paths_provider.dart';
import 'package_archive.dart';
import 'yandex_disk_transport.dart';

class SyncDiagnosticsSnapshot {
  const SyncDiagnosticsSnapshot({
    required this.deviceId,
    required this.lastReferencePackageId,
    required this.lastReferenceSyncAt,
    required this.lastResultPushAt,
    required this.lastResultPullAt,
    required this.lastSuccessAt,
    required this.lastSyncAttemptAt,
    required this.lastRetryAt,
    required this.lastConflictAt,
    required this.lastError,
    required this.pendingOutgoingCount,
    required this.pendingIncomingCount,
    required this.failedQueueCount,
    required this.retryEligibleCount,
    required this.conflictCount,
    required this.transportConfigured,
    required this.yandexDiskConnected,
  });

  final String? deviceId;
  final String? lastReferencePackageId;
  final String? lastReferenceSyncAt;
  final String? lastResultPushAt;
  final String? lastResultPullAt;
  final String? lastSuccessAt;
  final String? lastSyncAttemptAt;
  final String? lastRetryAt;
  final String? lastConflictAt;
  final String? lastError;
  final int pendingOutgoingCount;
  final int pendingIncomingCount;
  final int failedQueueCount;
  final int retryEligibleCount;
  final int conflictCount;
  final bool transportConfigured;
  final bool yandexDiskConnected;
}

enum SyncRunStatus { success, partial }

class SyncRunReport {
  const SyncRunReport({
    required this.status,
    required this.referencePublishedCount,
    required this.referencePulledCount,
    required this.resultPushedCount,
    required this.resultImportedCount,
    required this.conflictCount,
    required this.failureCount,
  });

  const SyncRunReport.empty()
      : status = SyncRunStatus.success,
        referencePublishedCount = 0,
        referencePulledCount = 0,
        resultPushedCount = 0,
        resultImportedCount = 0,
        conflictCount = 0,
        failureCount = 0;

  final SyncRunStatus status;
  final int referencePublishedCount;
  final int referencePulledCount;
  final int resultPushedCount;
  final int resultImportedCount;
  final int conflictCount;
  final int failureCount;

  bool get hasIssues => failureCount > 0 || conflictCount > 0;
  bool get hasActivity =>
      referencePublishedCount > 0 ||
      referencePulledCount > 0 ||
      resultPushedCount > 0 ||
      resultImportedCount > 0;

  String summaryLabel() {
    final parts = <String>[];
    if (referencePublishedCount > 0) {
      parts.add('опубликовано пакетов справочников: $referencePublishedCount');
    }
    if (referencePulledCount > 0) {
      parts.add('получено пакетов справочников: $referencePulledCount');
    }
    if (resultPushedCount > 0) {
      parts.add('отправлено результатов: $resultPushedCount');
    }
    if (resultImportedCount > 0) {
      parts.add('импортировано результатов: $resultImportedCount');
    }
    if (conflictCount > 0) {
      parts.add('конфликтов: $conflictCount');
    }
    if (failureCount > 0) {
      parts.add('ошибок: $failureCount');
    }
    if (parts.isEmpty) {
      return hasIssues
          ? 'Синхронизация завершена с проблемами.'
          : 'Синхронизация завершена, изменений нет.';
    }
    final prefix = switch (status) {
      SyncRunStatus.success => 'Синхронизация завершена',
      SyncRunStatus.partial => 'Синхронизация завершена с проблемами',
    };
    return '$prefix: ${parts.join(', ')}.';
  }
}

class _SyncBatchResult {
  const _SyncBatchResult({
    this.successCount = 0,
    this.failureCount = 0,
    this.conflictCount = 0,
  });

  final int successCount;
  final int failureCount;
  final int conflictCount;

  _SyncBatchResult operator +(_SyncBatchResult other) {
    return _SyncBatchResult(
      successCount: successCount + other.successCount,
      failureCount: failureCount + other.failureCount,
      conflictCount: conflictCount + other.conflictCount,
    );
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    db: ref.watch(appDatabaseProvider),
    paths: ref.watch(appPathsProvider),
    logger: ref.watch(bootstrapDataProvider).logger,
    transport: ref.watch(syncTransportProvider),
    packageArchive: ref.watch(packageArchiveProvider),
    referencePackageRepository: ref.watch(referencePackageRepositoryProvider),
    inspectionsRepository: ref.watch(inspectionsRepositoryProvider),
  );
});

final syncDiagnosticsProvider = FutureProvider<SyncDiagnosticsSnapshot>(
  (ref) => ref.watch(syncServiceProvider).loadDiagnostics(),
);

class SyncService {
  static const _retryActionType = 'sync.retry.run';

  SyncService({
    required AppDatabase db,
    required AppPaths paths,
    required AppLogger logger,
    required SyncTransport transport,
    required PackageArchive packageArchive,
    required ReferencePackageRepository referencePackageRepository,
    required InspectionsRepository inspectionsRepository,
  })  : _db = db,
        _paths = paths,
        _logger = logger,
        _transport = transport,
        _packageArchive = packageArchive,
        _referencePackageRepository = referencePackageRepository,
        _inspectionsRepository = inspectionsRepository;

  final AppDatabase _db;
  final AppPaths _paths;
  final AppLogger _logger;
  final SyncTransport _transport;
  final PackageArchive _packageArchive;
  final ReferencePackageRepository _referencePackageRepository;
  final InspectionsRepository _inspectionsRepository;

  Future<void> syncOnStartup({
    required AppPlatform platform,
    String? actorUserId,
  }) async {
    await runAutomaticRetrySync(
      platform: platform,
      actorUserId: actorUserId,
      trigger: 'startup',
    );
  }

  Future<void> syncOnResume({
    required AppPlatform platform,
    String? actorUserId,
  }) async {
    await runAutomaticRetrySync(
      platform: platform,
      actorUserId: actorUserId,
      trigger: 'resume',
    );
  }

  Future<void> runAutomaticRetrySync({
    required AppPlatform platform,
    String? actorUserId,
    required String trigger,
  }) async {
    if (actorUserId == null || platform == AppPlatform.unsupported) {
      return;
    }
    if (!await _canRunSyncAutomatically(
      platform: platform,
      actorUserId: actorUserId,
    )) {
      return;
    }
    if (!await _transport.isConfigured()) {
      return;
    }

    final retryEligibleCount = await _countRetryEligibleEntries();
    try {
      final report = await _runSyncCore(
        platform: platform,
        actorUserId: actorUserId,
        respectRetrySchedule: true,
      );
      await recordAudit(
        _db,
        actionType: _retryActionType,
        resultStatus: report.hasIssues
            ? 'partial'
            : report.hasActivity || retryEligibleCount > 0
                ? 'success'
                : 'noop',
        userId: actorUserId,
        entityType: 'device',
        entityId: (await _db.select(_db.deviceInfo).getSingleOrNull())?.id,
        message: report.summaryLabel(),
        payload: {
          'platform': platform.name,
          'trigger': trigger,
          'retry_eligible': retryEligibleCount,
          'reference_published': report.referencePublishedCount,
          'reference_pulled': report.referencePulledCount,
          'results_pushed': report.resultPushedCount,
          'results_imported': report.resultImportedCount,
          'conflicts': report.conflictCount,
          'failures': report.failureCount,
        },
      );
    } catch (error, stackTrace) {
      _logger.warning('Automatic sync ($trigger) failed: $error');
      await _recordSyncFailure(
        operation: _retryActionType,
        error: error,
        actorUserId: actorUserId,
        stackTrace: stackTrace,
      );
    }
  }

  Future<SyncRunReport> runManualSync({
    required AppPlatform platform,
    String? actorUserId,
  }) async {
    await _ensureManualSyncAllowed(
      platform: platform,
      actorUserId: actorUserId,
    );
    await recordAudit(
      _db,
      actionType: 'sync.run.start',
      resultStatus: 'pending',
      userId: actorUserId,
      entityType: 'device',
      entityId: (await _db.select(_db.deviceInfo).getSingleOrNull())?.id,
      message: 'Sync run started',
      payload: {'platform': platform.name},
    );

    final report = await _runSyncCore(
      platform: platform,
      actorUserId: actorUserId,
      respectRetrySchedule: false,
    );
    await recordAudit(
      _db,
      actionType: 'sync.run.finish',
      resultStatus: report.hasIssues ? 'partial' : 'success',
      userId: actorUserId,
      entityType: 'device',
      entityId: (await _db.select(_db.deviceInfo).getSingleOrNull())?.id,
      message: report.summaryLabel(),
      payload: {
        'platform': platform.name,
        'reference_published': report.referencePublishedCount,
        'reference_pulled': report.referencePulledCount,
        'results_pushed': report.resultPushedCount,
        'results_imported': report.resultImportedCount,
        'conflicts': report.conflictCount,
        'failures': report.failureCount,
      },
    );
    return report;
  }

  Future<SyncRunReport> _runSyncCore({
    required AppPlatform platform,
    required String? actorUserId,
    required bool respectRetrySchedule,
  }) async {
    await _ensureConfiguredTransport();
    await _transport.ensureRemoteLayout();

    var publishedReferenceCount = 0;
    var pulledReferenceCount = 0;
    var pushedResultCount = 0;
    var importedResultCount = 0;
    var conflictCount = 0;
    var failureCount = 0;

    switch (platform) {
      case AppPlatform.windows:
        final publishResult = await _publishPendingReferencePackages(
          actorUserId: actorUserId,
          respectRetrySchedule: respectRetrySchedule,
        );
        final importResult = await _importIncomingResultPackages(
          actorUserId: actorUserId,
          respectRetrySchedule: respectRetrySchedule,
        );
        publishedReferenceCount += publishResult.successCount;
        importedResultCount += importResult.successCount;
        conflictCount += importResult.conflictCount;
        failureCount += publishResult.failureCount + importResult.failureCount;
      case AppPlatform.android:
        final pullResult = await _pullLatestReferencePackage(
          actorUserId: actorUserId,
        );
        final pushResult = await _pushQueuedResultPackages(
          actorUserId: actorUserId,
          respectRetrySchedule: respectRetrySchedule,
        );
        pulledReferenceCount += pullResult.successCount;
        pushedResultCount += pushResult.successCount;
        failureCount += pullResult.failureCount + pushResult.failureCount;
      case AppPlatform.unsupported:
        throw StateError('Синхронизация не поддерживается на этой платформе.');
    }

    final report = SyncRunReport(
      status: failureCount > 0 || conflictCount > 0
          ? SyncRunStatus.partial
          : SyncRunStatus.success,
      referencePublishedCount: publishedReferenceCount,
      referencePulledCount: pulledReferenceCount,
      resultPushedCount: pushedResultCount,
      resultImportedCount: importedResultCount,
      conflictCount: conflictCount,
      failureCount: failureCount,
    );

    if (report.hasIssues) {
      await _markSyncPartial(report.summaryLabel());
    } else {
      await _markSyncSuccess();
    }
    return report;
  }

  Future<ReferencePackageResult> publishReferencePackage({
    String? actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.manageSync,
      deniedMessage: 'Только администратор может публиковать пакеты справочников.',
    );
    await _ensureConfiguredTransport();
    final result = await _referencePackageRepository.exportPackage(
      actorUserId: actorUserId,
    );
    await _publishPendingReferencePackages(
      actorUserId: actorUserId,
      respectRetrySchedule: false,
    );
    await _markSyncSuccess();
    return result;
  }

  Future<InspectionDraftDetail> startInspectionDraft({
    required InspectionStartRequest request,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: request.userId,
      capability: AppCapability.startInspection,
      deniedMessage: 'Эта роль не может запускать проверки.',
    );
    var lockAcquired = false;
    try {
      await _runBestEffortAndroidSync(actorUserId: request.userId);
      lockAcquired = await _acquireRemoteLockIfPossible(
        productObjectId: request.productObjectId,
        userId: request.userId,
      );
      return await _inspectionsRepository.startOrResumeDraft(request);
    } on StateError {
      if (lockAcquired) {
        await _releaseRemoteLockBestEffort(
          productObjectId: request.productObjectId,
          actorUserId: request.userId,
        );
      }
      rethrow;
    }
  }

  Future<InspectionCompletionStatus> completeInspection({
    required String inspectionId,
    required String actorUserId,
  }) async {
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: AppCapability.completeInspection,
      deniedMessage: 'Эта роль не может завершать проверки.',
    );
    final completion = await _inspectionsRepository.completeInspection(
      inspectionId: inspectionId,
      actorUserId: actorUserId,
    );
    final inspection = await (_db.select(_db.inspections)
          ..where((tbl) => tbl.id.equals(inspectionId)))
        .getSingle();
    await _releaseRemoteLockBestEffort(
      productObjectId: inspection.productObjectId,
      actorUserId: actorUserId,
    );
    await _runBestEffortAndroidSync(actorUserId: actorUserId);
    return completion;
  }

  Future<SyncDiagnosticsSnapshot> loadDiagnostics() async {
    final device = await _db.select(_db.deviceInfo).getSingleOrNull();
    final syncState = await _loadSyncState();
    final transportConfigured = await _transport.isConfigured();
    final pendingOutgoingExpression = _db.syncQueue.id.count();
    final pendingOutgoing = await (_db.selectOnly(_db.syncQueue)
          ..addColumns([pendingOutgoingExpression])
          ..where(
            _db.syncQueue.direction.equals('outgoing') &
                (_db.syncQueue.status.equals('pending') |
                    _db.syncQueue.status.equals('processing')),
          ))
        .getSingle();
    final pendingIncomingExpression = _db.syncQueue.id.count();
    final pendingIncoming = await (_db.selectOnly(_db.syncQueue)
          ..addColumns([pendingIncomingExpression])
          ..where(
            _db.syncQueue.direction.equals('incoming') &
                (_db.syncQueue.status.equals('pending') |
                    _db.syncQueue.status.equals('processing')),
          ))
        .getSingle();
    final failedExpression = _db.syncQueue.id.count();
    final failed = await (_db.selectOnly(_db.syncQueue)
          ..addColumns([failedExpression])
          ..where(_db.syncQueue.status.equals('failed')))
        .getSingle();
    final retryEligibleExpression = _db.syncQueue.id.count();
    final retryEligible = await (_db.selectOnly(_db.syncQueue)
          ..addColumns([retryEligibleExpression])
          ..where(_retryEligibleQueueExpression(_db.syncQueue, nowIso())))
        .getSingle();
    final conflictExpression = _db.inspections.id.count();
    final conflicts = await (_db.selectOnly(_db.inspections)
          ..addColumns([conflictExpression])
          ..where(
            _db.inspections.status.equals('conflict') |
                _db.inspections.syncStatus.equals('conflict'),
          ))
        .getSingle();
    final lastConflict = await (_db.select(_db.auditLog)
          ..where((tbl) => tbl.actionType.equals('sync.result.conflict'))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.happenedAt)])
          ..limit(1))
        .getSingleOrNull();
    final lastRetry = await (_db.select(_db.auditLog)
          ..where((tbl) => tbl.actionType.equals(_retryActionType))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.happenedAt)])
          ..limit(1))
        .getSingleOrNull();

    return SyncDiagnosticsSnapshot(
      deviceId: device?.id,
      lastReferencePackageId: syncState?.lastReferencePackageId,
      lastReferenceSyncAt: syncState?.lastReferenceSyncAt,
      lastResultPushAt: syncState?.lastResultPushAt,
      lastResultPullAt: syncState?.lastResultPullAt,
      lastSuccessAt: syncState?.lastSuccessAt,
      lastSyncAttemptAt: syncState?.updatedAt,
      lastRetryAt: lastRetry?.happenedAt,
      lastConflictAt: lastConflict?.happenedAt,
      lastError: syncState?.lastError,
      pendingOutgoingCount:
          pendingOutgoing.read(pendingOutgoingExpression) ?? 0,
      pendingIncomingCount:
          pendingIncoming.read(pendingIncomingExpression) ?? 0,
      failedQueueCount: failed.read(failedExpression) ?? 0,
      retryEligibleCount: retryEligible.read(retryEligibleExpression) ?? 0,
      conflictCount: conflicts.read(conflictExpression) ?? 0,
      transportConfigured: transportConfigured,
      yandexDiskConnected: device?.yandexDiskConnected ?? false,
    );
  }

  Future<_SyncBatchResult> _publishPendingReferencePackages({
    String? actorUserId,
    required bool respectRetrySchedule,
  }) async {
    final pendingPackages = await _loadOutgoingPackagesForRun(
      packageType: 'reference',
      respectRetrySchedule: respectRetrySchedule,
    );
    if (pendingPackages.isEmpty) {
      return const _SyncBatchResult();
    }

    var successCount = 0;
    var failureCount = 0;
    for (final queueEntry in pendingPackages) {
      await _markQueueProcessing(queueEntry.id);
      try {
        final packageDirectory = Directory(
          _paths.resolveRelativePath(queueEntry.localPath),
        );
        final manifestFile = File(p.join(packageDirectory.path, 'manifest.json'));
        final manifest = await _readJsonFile(manifestFile);
        final packageId = manifest['package_id']?.toString() ?? queueEntry.packageId;
        final zipFile = await _packageArchive.zipDirectory(
          sourceDirectory: packageDirectory,
          destinationFile: File(
            p.join(_paths.syncTempDir.path, 'reference_$packageId.zip'),
          ),
        );

        await _transport.uploadFile(
          remotePath: 'reference_data/packages/reference_$packageId.zip',
          file: zipFile,
          contentType: 'application/zip',
        );
        await _uploadReferenceMedia(manifest);
        await _uploadGlobalManifest(
          currentPackageId: packageId,
          currentPackageChecksum: await checksumFile(zipFile),
        );

        final syncedAt = nowIso();
        await _markQueueDone(queueEntry.id);
        await _upsertSyncState(
          lastReferencePackageId: packageId,
          lastReferenceSyncAt: syncedAt,
          lastSuccessAt: syncedAt,
          lastError: null,
        );
        await recordAudit(
          _db,
          actionType: 'sync.reference.publish',
          resultStatus: 'success',
          userId: actorUserId,
          entityType: 'reference_package',
          entityId: packageId,
          message: 'Reference package uploaded to Yandex Disk',
        );
        successCount += 1;
      } catch (error, stackTrace) {
        await _markQueueFailed(queueEntry.id, error.toString());
        await _recordSyncFailure(
          operation: 'sync.reference.publish',
          error: error,
          actorUserId: actorUserId,
          stackTrace: stackTrace,
          entityId: queueEntry.packageId,
        );
        failureCount += 1;
      }
    }
    return _SyncBatchResult(
      successCount: successCount,
      failureCount: failureCount,
    );
  }

  Future<_SyncBatchResult> _pushQueuedResultPackages({
    String? actorUserId,
    required bool respectRetrySchedule,
  }) async {
    final pendingPackages = await _loadOutgoingPackagesForRun(
      packageType: 'inspection_result',
      respectRetrySchedule: respectRetrySchedule,
    );
    if (pendingPackages.isEmpty) {
      return const _SyncBatchResult();
    }

    var successCount = 0;
    var failureCount = 0;
    for (final queueEntry in pendingPackages) {
      await _markQueueProcessing(queueEntry.id);
      try {
        final packageDirectory = Directory(
          _paths.resolveRelativePath(queueEntry.localPath),
        );
        final packageId = queueEntry.packageId;
        final zipFile = await _packageArchive.zipDirectory(
          sourceDirectory: packageDirectory,
          destinationFile: File(
            p.join(_paths.syncTempDir.path, 'result_$packageId.zip'),
          ),
        );
        await _transport.uploadFile(
          remotePath: 'results/incoming/result_$packageId.zip',
          file: zipFile,
          contentType: 'application/zip',
        );
        final pushedAt = nowIso();
        await _markQueueDone(queueEntry.id);
        await (_db.update(_db.inspections)
              ..where((tbl) => tbl.id.equals(packageId)))
            .write(
          InspectionsCompanion(
            syncStatus: const Value('uploaded'),
            updatedAt: Value(pushedAt),
          ),
        );
        await _upsertSyncState(
          lastResultPushAt: pushedAt,
          lastSuccessAt: pushedAt,
          lastError: null,
        );
        await recordAudit(
          _db,
          actionType: 'sync.result.push',
          resultStatus: 'success',
          userId: actorUserId,
          entityType: 'inspection',
          entityId: packageId,
          message: 'Inspection result uploaded to Yandex Disk',
        );
        successCount += 1;
      } catch (error, stackTrace) {
        await _markQueueFailed(queueEntry.id, error.toString());
        await _recordSyncFailure(
          operation: 'sync.result.push',
          error: error,
          actorUserId: actorUserId,
          stackTrace: stackTrace,
          entityId: queueEntry.packageId,
        );
        failureCount += 1;
      }
    }
    return _SyncBatchResult(
      successCount: successCount,
      failureCount: failureCount,
    );
  }

  Future<_SyncBatchResult> _pullLatestReferencePackage({
    String? actorUserId,
  }) async {
    final globalManifestRaw =
        await _transport.downloadString('manifest/global_manifest.json');
    if (globalManifestRaw == null) {
      return const _SyncBatchResult();
    }

    final globalManifest = jsonDecode(globalManifestRaw) as Map<String, dynamic>;
    final packageId =
        nullableField(globalManifest['current_reference_package_id']?.toString());
    if (packageId == null) {
      return const _SyncBatchResult();
    }

    final syncState = await _loadSyncState();
    if (syncState?.lastReferencePackageId == packageId) {
      return const _SyncBatchResult();
    }

    final localZip = File(
      p.join(_paths.syncTempDir.path, 'reference_$packageId.zip'),
    );
    final extractDir = Directory(
      p.join(_paths.syncTempDir.path, 'reference_$packageId'),
    );

    try {
      await _transport.downloadFile(
        remotePath: 'reference_data/packages/reference_$packageId.zip',
        destinationFile: localZip,
      );
      await _packageArchive.unzipFile(
        sourceFile: localZip,
        destinationDirectory: extractDir,
      );

      final manifest =
          await _readJsonFile(File(p.join(extractDir.path, 'manifest.json')));
      await _importReferenceSnapshot(extractDir);
      await _downloadReferenceMedia(manifest);

      final syncedAt = nowIso();
      await _upsertSyncState(
        lastReferencePackageId: packageId,
        lastReferenceSyncAt: syncedAt,
        lastSuccessAt: syncedAt,
        lastError: null,
      );
      await recordAudit(
        _db,
        actionType: 'sync.reference.pull',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'reference_package',
        entityId: packageId,
        message: 'Reference package imported from Yandex Disk',
      );
      return const _SyncBatchResult(successCount: 1);
    } catch (error, stackTrace) {
      await _recordSyncFailure(
        operation: 'sync.reference.pull',
        error: error,
        actorUserId: actorUserId,
        stackTrace: stackTrace,
        entityId: packageId,
      );
      return const _SyncBatchResult(failureCount: 1);
    }
  }

  Future<_SyncBatchResult> _importIncomingResultPackages({
    String? actorUserId,
    required bool respectRetrySchedule,
  }) async {
    final remoteEntries = await _transport.listFiles('results/incoming');
    final packages = remoteEntries
        .where(
          (entry) =>
              entry.type == 'file' &&
              entry.name.startsWith('result_') &&
              entry.name.endsWith('.zip'),
        )
        .toList(growable: false);

    var successCount = 0;
    var failureCount = 0;
    var conflictCount = 0;
    for (final entry in packages) {
      final fileName = entry.name;
      final packageId = fileName
          .replaceFirst(RegExp(r'^result_'), '')
          .replaceFirst(RegExp(r'\.zip$'), '');
      final localZip = File(p.join(_paths.syncIncomingDir.path, fileName));
      final extractDir = Directory(p.join(_paths.syncTempDir.path, packageId));
      final existingQueue = await (_db.select(_db.syncQueue)
            ..where(
              (tbl) =>
                  tbl.direction.equals('incoming') &
                  tbl.packageType.equals('inspection_result') &
                  tbl.packageId.equals(packageId),
            )
            ..limit(1))
          .getSingleOrNull();
      if (!_shouldProcessQueueEntry(
        existingQueue,
        respectRetrySchedule: respectRetrySchedule,
      )) {
        continue;
      }
      final queueId = await _upsertIncomingQueueRecord(
        packageId: packageId,
        localPath: _paths.relativeToRoot(localZip.path),
        status: 'processing',
      );

      try {
        await _transport.downloadFile(
          remotePath: 'results/incoming/$fileName',
          destinationFile: localZip,
        );
        await _packageArchive.unzipFile(
          sourceFile: localZip,
          destinationDirectory: extractDir,
        );

        final status = await _importResultPackage(
          extractDir: extractDir,
          packageId: packageId,
          actorUserId: actorUserId,
        );

        final remoteArchivePath = status == 'conflict'
            ? 'results/conflicts/$fileName'
            : 'results/processed/$fileName';
        await _transport.uploadFile(
          remotePath: remoteArchivePath,
          file: localZip,
          contentType: 'application/zip',
        );
        await _transport.deletePath('results/incoming/$fileName');

        final localProcessedFile = File(p.join(_paths.syncProcessedDir.path, fileName));
        if (await localProcessedFile.exists()) {
          await localProcessedFile.delete();
        }
        await localProcessedFile.parent.create(recursive: true);
        await localZip.copy(localProcessedFile.path);
        await localZip.delete();

        final pulledAt = nowIso();
        await _updateIncomingQueueStatus(
          queueId: queueId,
          status: status == 'conflict' ? 'conflict' : 'done',
          localPath: _paths.relativeToRoot(localProcessedFile.path),
        );
        await _upsertSyncState(
          lastResultPullAt: pulledAt,
          lastSuccessAt: pulledAt,
          lastError: null,
        );
        if (status == 'conflict') {
          conflictCount += 1;
        } else {
          successCount += 1;
        }
      } catch (error, stackTrace) {
        await _markQueueFailed(
          queueId,
          error.toString(),
          localPath: _paths.relativeToRoot(localZip.path),
        );
        await _recordSyncFailure(
          operation: 'sync.result.pull',
          error: error,
          actorUserId: actorUserId,
          stackTrace: stackTrace,
          entityId: packageId,
        );
        failureCount += 1;
      }
    }
    return _SyncBatchResult(
      successCount: successCount,
      failureCount: failureCount,
      conflictCount: conflictCount,
    );
  }

  Future<String> _importResultPackage({
    required Directory extractDir,
    required String packageId,
    String? actorUserId,
  }) async {
    final manifest =
        await _readJsonFile(File(p.join(extractDir.path, 'manifest.json')));
    final inspectionPayload = await _readJsonFile(
      File(p.join(extractDir.path, 'data', 'inspection.json')),
    );
    final itemsPayload = await _readJsonList(
      File(p.join(extractDir.path, 'data', 'inspection_items.json')),
    );
    final signaturesPayload = await _readJsonList(
      File(p.join(extractDir.path, 'data', 'inspection_signatures.json')),
    );
    final filesPayload = await _readJsonList(
      File(p.join(extractDir.path, 'data', 'inspection_files.json')),
    );

    final inspectionId = _readRequiredString(inspectionPayload, 'id');
    final sourceReferencePackageId =
        nullableField(inspectionPayload['source_reference_package_id']?.toString());
    final syncState = await _loadSyncState();
    final existingInspection = await (_db.select(_db.inspections)
          ..where((tbl) => tbl.id.equals(inspectionId)))
        .getSingleOrNull();

    String? conflictReason;
    if (existingInspection != null) {
      conflictReason = 'Duplicate inspection package import.';
    } else if (syncState?.lastReferencePackageId != null &&
        sourceReferencePackageId != null &&
        sourceReferencePackageId != syncState!.lastReferencePackageId) {
      conflictReason = 'Inspection result references an outdated reference package.';
    }

    if (conflictReason != null) {
      await _storeConflictInspection(
        inspectionPayload: inspectionPayload,
        conflictReason: conflictReason,
      );
      await recordAudit(
        _db,
        actionType: 'sync.result.conflict',
        resultStatus: 'conflict',
        userId: actorUserId,
        entityType: 'inspection',
        entityId: inspectionId,
        message: conflictReason,
        payload: {
          'package_id': packageId,
          'manifest': manifest,
        },
      );
      return 'conflict';
    }

    final signatureEntries = await _copyImportedSignatures(
      inspectionId: inspectionId,
      signaturesPayload: signaturesPayload,
      extractDir: extractDir,
    );
    final importedPdf = await _copyImportedPdf(
      inspectionId: inspectionId,
      filesPayload: filesPayload,
      extractDir: extractDir,
    );

    final now = nowIso();
    await _db.transaction(() async {
      await _db.into(_db.inspections).insert(
            InspectionsCompanion.insert(
              id: inspectionId,
              deviceId: _readRequiredString(inspectionPayload, 'device_id'),
              userId: _readRequiredString(inspectionPayload, 'user_id'),
              productObjectId: _readRequiredString(
                inspectionPayload,
                'product_object_id',
              ),
              targetObjectId: _readRequiredString(
                inspectionPayload,
                'target_object_id',
              ),
              startedAt: _readRequiredString(inspectionPayload, 'started_at'),
              completedAt: driftValue(
                nullableField(inspectionPayload['completed_at']?.toString()),
              ),
              status: 'synced',
              syncStatus: 'imported',
              sourceReferencePackageId: driftValue(sourceReferencePackageId),
              sourceReferenceVersion: driftValue(
                nullableField(
                  inspectionPayload['source_reference_version']?.toString(),
                ),
              ),
              pdfLocalPath: driftValue(importedPdf?.relativePath),
              pdfChecksum: driftValue(importedPdf?.checksum),
              conflictReason: const Value.absent(),
              createdAt: _readRequiredString(inspectionPayload, 'created_at'),
              updatedAt: now,
            ),
          );

      await _db.batch((batch) {
        batch.insertAll(
          _db.inspectionItems,
          itemsPayload
              .map(
                (row) => InspectionItemsCompanion.insert(
                  id: _readRequiredString(row, 'answer_id'),
                  inspectionId: inspectionId,
                  checklistItemId: _readRequiredString(row, 'checklist_item_id'),
                  componentId: driftValue(nullableField(row['component_id']?.toString())),
                  resultStatus: Value(_readRequiredString(row, 'result_status')),
                  comment: driftValue(nullableField(row['comment']?.toString())),
                  measuredValue:
                      driftValue(nullableField(row['measured_value']?.toString())),
                  sortOrder: Value(_readInt(row['sort_order'])),
                  createdAt: now,
                  updatedAt: now,
                ),
              )
              .toList(growable: false),
        );
        if (signatureEntries.isNotEmpty) {
          batch.insertAll(_db.inspectionSignatures, signatureEntries);
        }
        if (importedPdf != null) {
          batch.insertAll(_db.inspectionFiles, [
            InspectionFilesCompanion.insert(
              id: generateId('inspection-file'),
              inspectionId: inspectionId,
              fileType: 'pdf',
              fileName: p.basename(importedPdf.absolutePath),
              localPath: importedPdf.relativePath,
              checksum: importedPdf.checksum,
              mimeType: 'application/pdf',
              createdAt: now,
              updatedAt: now,
            ),
          ]);
        }
      });
    });

    await recordAudit(
      _db,
      actionType: 'sync.result.import',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'inspection',
      entityId: inspectionId,
      message: 'Inspection result imported from Yandex Disk',
    );
    return 'done';
  }

  Future<void> _importReferenceSnapshot(Directory extractDir) async {
    final users = await _readJsonList(File(p.join(extractDir.path, 'data', 'users.json')));
    final orgStructure = await _readJsonFile(
      File(p.join(extractDir.path, 'data', 'org_structure.json')),
    );
    final objects = await _readJsonList(
      File(p.join(extractDir.path, 'data', 'objects.json')),
    );
    final relations = await _readJsonList(
      File(p.join(extractDir.path, 'data', 'object_relations.json')),
    );
    final components = await _readJsonList(
      File(p.join(extractDir.path, 'data', 'components.json')),
    );
    final componentImages = await _readJsonList(
      File(p.join(extractDir.path, 'data', 'component_images.json')),
    );
    final checklists = await _readJsonList(
      File(p.join(extractDir.path, 'data', 'checklists.json')),
    );
    final checklistItems = await _readJsonList(
      File(p.join(extractDir.path, 'data', 'checklist_items.json')),
    );
    final checklistBindings = await _readJsonList(
      File(p.join(extractDir.path, 'data', 'checklist_bindings.json')),
    );

    final departments =
        _mapList(orgStructure['departments']).toList(growable: false);
    final workshops = _mapList(orgStructure['workshops']).toList(growable: false);
    final sections = _mapList(orgStructure['sections']).toList(growable: false);

    await _db.transaction(() async {
      await _db.delete(_db.checklistBindings).go();
      await _db.delete(_db.checklistItems).go();
      await _db.delete(_db.checklists).go();
      await _db.delete(_db.componentImages).go();
      await _db.delete(_db.components).go();
      await _db.delete(_db.objectRelations).go();
      await _db.delete(_db.catalogObjects).go();
      await _db.delete(_db.sections).go();
      await _db.delete(_db.workshops).go();
      await _db.delete(_db.departments).go();
      await _db.delete(_db.users).go();

      await _db.batch((batch) {
        if (users.isNotEmpty) {
          batch.insertAll(
            _db.users,
            users
                .map(
                  (row) => UsersCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    fullName: _readRequiredString(row, 'full_name'),
                    shortName: driftValue(nullableField(row['short_name']?.toString())),
                    roleId: _readRequiredString(row, 'role_id'),
                    isActive: Value(_readBool(row['is_active'])),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                  ),
                )
                .toList(growable: false),
          );
        }
        if (departments.isNotEmpty) {
          batch.insertAll(
            _db.departments,
            departments
                .map(
                  (row) => DepartmentsCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    name: _readRequiredString(row, 'name'),
                    code: driftValue(nullableField(row['code']?.toString())),
                    sortOrder: Value(_readInt(row['sort_order'])),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                  ),
                )
                .toList(growable: false),
          );
        }
        if (workshops.isNotEmpty) {
          batch.insertAll(
            _db.workshops,
            workshops
                .map(
                  (row) => WorkshopsCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    departmentId: _readRequiredString(row, 'department_id'),
                    name: _readRequiredString(row, 'name'),
                    code: driftValue(nullableField(row['code']?.toString())),
                    sortOrder: Value(_readInt(row['sort_order'])),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                  ),
                )
                .toList(growable: false),
          );
        }
        if (sections.isNotEmpty) {
          batch.insertAll(
            _db.sections,
            sections
                .map(
                  (row) => SectionsCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    workshopId: _readRequiredString(row, 'workshop_id'),
                    name: _readRequiredString(row, 'name'),
                    code: driftValue(nullableField(row['code']?.toString())),
                    sortOrder: Value(_readInt(row['sort_order'])),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                  ),
                )
                .toList(growable: false),
          );
        }
        if (objects.isNotEmpty) {
          batch.insertAll(
            _db.catalogObjects,
            objects
                .map(
                  (row) => CatalogObjectsCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    type: _readRequiredString(row, 'type'),
                    sectionId: driftValue(nullableField(row['section_id']?.toString())),
                    parentId: driftValue(nullableField(row['parent_id']?.toString())),
                    name: _readRequiredString(row, 'name'),
                    code: driftValue(nullableField(row['code']?.toString())),
                    description:
                        driftValue(nullableField(row['description']?.toString())),
                    sortOrder: Value(_readInt(row['sort_order'])),
                    isActive: Value(_readBool(row['is_active'], defaultValue: true)),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                  ),
                )
                .toList(growable: false),
          );
        }
        if (relations.isNotEmpty) {
          batch.insertAll(
            _db.objectRelations,
            relations
                .map(
                  (row) => ObjectRelationsCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    parentObjectId: _readRequiredString(row, 'parent_object_id'),
                    childObjectId: _readRequiredString(row, 'child_object_id'),
                    relationType: Value(_readRequiredString(row, 'relation_type')),
                    sortOrder: Value(_readInt(row['sort_order'])),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                  ),
                )
                .toList(growable: false),
          );
        }
        if (components.isNotEmpty) {
          batch.insertAll(
            _db.components,
            components
                .map(
                  (row) => ComponentsCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    objectId: _readRequiredString(row, 'object_id'),
                    name: _readRequiredString(row, 'name'),
                    code: driftValue(nullableField(row['code']?.toString())),
                    description:
                        driftValue(nullableField(row['description']?.toString())),
                    sortOrder: Value(_readInt(row['sort_order'])),
                    isRequired: Value(_readBool(row['is_required'])),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                  ),
                )
                .toList(growable: false),
          );
        }
        if (componentImages.isNotEmpty) {
          batch.insertAll(
            _db.componentImages,
            componentImages
                .map(
                  (row) => ComponentImagesCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    componentId: _readRequiredString(row, 'component_id'),
                    fileName: _readRequiredString(row, 'file_name'),
                    mediaKey: _readRequiredString(row, 'media_key'),
                    localPath: driftValue(nullableField(row['local_path']?.toString())),
                    checksum: _readRequiredString(row, 'checksum'),
                    mimeType: _readRequiredString(row, 'mime_type'),
                    sortOrder: Value(_readInt(row['sort_order'])),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                  ),
                )
                .toList(growable: false),
          );
        }
        if (checklists.isNotEmpty) {
          batch.insertAll(
            _db.checklists,
            checklists
                .map(
                  (row) => ChecklistsCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    name: _readRequiredString(row, 'name'),
                    description:
                        driftValue(nullableField(row['description']?.toString())),
                    isActive: Value(_readBool(row['is_active'], defaultValue: true)),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                  ),
                )
                .toList(growable: false),
          );
        }
        if (checklistItems.isNotEmpty) {
          batch.insertAll(
            _db.checklistItems,
            checklistItems
                .map(
                  (row) => ChecklistItemsCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    checklistId: _readRequiredString(row, 'checklist_id'),
                    componentId: driftValue(nullableField(row['component_id']?.toString())),
                    title: _readRequiredString(row, 'title'),
                    description:
                        driftValue(nullableField(row['description']?.toString())),
                    expectedResult:
                        driftValue(nullableField(row['expected_result']?.toString())),
                    resultType: Value(_readRequiredString(row, 'result_type')),
                    isRequired: Value(_readBool(row['is_required'])),
                    sortOrder: Value(_readInt(row['sort_order'])),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                  ),
                )
                .toList(growable: false),
          );
        }
        if (checklistBindings.isNotEmpty) {
          batch.insertAll(
            _db.checklistBindings,
            checklistBindings
                .map(
                  (row) => ChecklistBindingsCompanion.insert(
                    id: _readRequiredString(row, 'id'),
                    checklistId: _readRequiredString(row, 'checklist_id'),
                    targetType: _readRequiredString(row, 'target_type'),
                    targetId: driftValue(nullableField(row['target_id']?.toString())),
                    targetObjectType:
                        driftValue(nullableField(row['target_object_type']?.toString())),
                    priority: Value(_readInt(row['priority'])),
                    isRequired: Value(_readBool(row['is_required'])),
                    createdAt: _readRequiredString(row, 'created_at'),
                    updatedAt: _readRequiredString(row, 'updated_at'),
                    version: Value(_readInt(row['version'], defaultValue: 1)),
                  ),
                )
                .toList(growable: false),
          );
        }
      });
    });
  }

  Future<void> _uploadReferenceMedia(Map<String, dynamic> manifest) async {
    final requiredMedia = _mapList(manifest['required_media']).toList(growable: false);
    for (final media in requiredMedia) {
      final relativePath = nullableField(media['local_path']?.toString());
      if (relativePath == null) {
        continue;
      }
      final file = File(_paths.resolveRelativePath(relativePath));
      if (!await file.exists()) {
        continue;
      }
      await _transport.uploadFile(
        remotePath: relativePath.replaceAll('\\', '/'),
        file: file,
      );
    }
  }

  Future<void> _downloadReferenceMedia(Map<String, dynamic> manifest) async {
    final requiredMedia = _mapList(manifest['required_media']).toList(growable: false);
    for (final media in requiredMedia) {
      final relativePath = nullableField(media['local_path']?.toString());
      if (relativePath == null) {
        continue;
      }
      final destination = File(_paths.resolveRelativePath(relativePath));
      await _transport.downloadFile(
        remotePath: relativePath.replaceAll('\\', '/'),
        destinationFile: destination,
      );
      final expectedChecksum = nullableField(media['checksum']?.toString());
      if (expectedChecksum != null) {
        final actualChecksum = await checksumFile(destination);
        if (actualChecksum != expectedChecksum) {
          throw StateError('Checksum mismatch for downloaded media $relativePath.');
        }
      }
    }
  }

  Future<void> _uploadGlobalManifest({
    required String currentPackageId,
    required String currentPackageChecksum,
  }) async {
    final device = await _db.select(_db.deviceInfo).getSingleOrNull();
    final manifest = {
      'schema_version': AppConstants.syncSchemaVersion,
      'generated_at': nowIso(),
      'current_reference_package_id': currentPackageId,
      'current_reference_package_checksum': currentPackageChecksum,
      'available_reference_packages': [
        {
          'package_id': currentPackageId,
          'path': 'reference_data/packages/reference_$currentPackageId.zip',
          'checksum': currentPackageChecksum,
        },
      ],
      'registered_devices': [
        if (device != null)
          {
            'device_id': device.id,
            'platform': device.platform,
            'app_version': device.appVersion,
          },
      ],
    };

    await _transport.uploadString(
      remotePath: 'manifest/global_manifest.json',
      content: const JsonEncoder.withIndent('  ').convert(manifest),
    );
  }

  Future<bool> _acquireRemoteLockIfPossible({
    required String productObjectId,
    required String userId,
  }) async {
    if (!await _transport.isConfigured()) {
      return false;
    }

    final device = await _db.select(_db.deviceInfo).getSingleOrNull();
    final deviceId = device?.id ?? AppConstants.defaultDeviceId;
    final remotePath = 'locks/$productObjectId.lock.json';
    final now = DateTime.now().toUtc();
    final expiresAt = now.add(const Duration(hours: 8));

    try {
      final existingRaw = await _transport.downloadString(remotePath);
      if (existingRaw != null) {
        final existing = jsonDecode(existingRaw) as Map<String, dynamic>;
        final existingExpiresAt = DateTime.tryParse(
          existing['expires_at']?.toString() ?? '',
        );
        final existingDeviceId = existing['device_id']?.toString();
        final existingUserId = existing['user_id']?.toString();
        final isExpired =
            existingExpiresAt == null || existingExpiresAt.isBefore(now);
        final isOwnedByCurrent =
            existingDeviceId == deviceId && existingUserId == userId;

        if (!isExpired && !isOwnedByCurrent) {
          throw StateError(
            'Another device already holds a lock for this product until ${existing['expires_at']}.',
          );
        }
      }

      final payload = {
        'lock_id': generateId('lock'),
        'product_object_id': productObjectId,
        'device_id': deviceId,
        'user_id': userId,
        'created_at': now.toIso8601String(),
        'expires_at': expiresAt.toIso8601String(),
      };
      await _transport.uploadString(
        remotePath: remotePath,
        content: const JsonEncoder.withIndent('  ').convert(payload),
      );
      await _upsertLocalLock(
        productObjectId: productObjectId,
        remoteLockKey: remotePath,
        deviceId: deviceId,
        userId: userId,
        acquiredAt: now.toIso8601String(),
        expiresAt: expiresAt.toIso8601String(),
      );
      return true;
    } on StateError {
      rethrow;
    } catch (error) {
      _logger.warning('Lock acquisition skipped for $productObjectId: $error');
      return false;
    }
  }

  Future<void> _releaseRemoteLockBestEffort({
    required String productObjectId,
    String? actorUserId,
  }) async {
    final activeLock = await (_db.select(_db.locks)
          ..where(
            (tbl) =>
                tbl.productObjectId.equals(productObjectId) &
                tbl.status.equals('active'),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (activeLock == null) {
      return;
    }

    try {
      if (await _transport.isConfigured()) {
        final existingRaw = await _transport.downloadString(activeLock.remoteLockKey);
        if (existingRaw != null) {
          final existing = jsonDecode(existingRaw) as Map<String, dynamic>;
          final sameOwner =
              existing['device_id']?.toString() == activeLock.deviceId &&
                  existing['user_id']?.toString() == activeLock.userId;
          if (sameOwner) {
            await _transport.deletePath(activeLock.remoteLockKey);
          }
        }
      }
    } catch (error) {
      _logger.warning('Remote lock release failed for $productObjectId: $error');
    } finally {
      final releasedAt = nowIso();
      await (_db.update(_db.locks)..where((tbl) => tbl.id.equals(activeLock.id))).write(
        LocksCompanion(
          status: const Value('released'),
          releasedAt: Value(releasedAt),
          updatedAt: Value(releasedAt),
        ),
      );
      await recordAudit(
        _db,
        actionType: 'sync.lock.release',
        resultStatus: 'success',
        userId: actorUserId,
        entityType: 'lock',
        entityId: activeLock.id,
        message: 'Product lock released',
      );
    }
  }

  Future<void> _upsertLocalLock({
    required String productObjectId,
    required String remoteLockKey,
    required String deviceId,
    required String userId,
    required String acquiredAt,
    required String expiresAt,
  }) async {
    final existing = await (_db.select(_db.locks)
          ..where(
            (tbl) =>
                tbl.productObjectId.equals(productObjectId) &
                tbl.status.equals('active'),
          )
          ..limit(1))
        .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.locks).insert(
            LocksCompanion.insert(
              id: generateId('lock'),
              productObjectId: productObjectId,
              remoteLockKey: remoteLockKey,
              deviceId: deviceId,
              userId: userId,
              status: 'active',
              acquiredAt: acquiredAt,
              expiresAt: expiresAt,
              createdAt: acquiredAt,
              updatedAt: acquiredAt,
            ),
          );
      return;
    }

    await (_db.update(_db.locks)..where((tbl) => tbl.id.equals(existing.id))).write(
      LocksCompanion(
        remoteLockKey: Value(remoteLockKey),
        deviceId: Value(deviceId),
        userId: Value(userId),
        status: const Value('active'),
        acquiredAt: Value(acquiredAt),
        expiresAt: Value(expiresAt),
        releasedAt: const Value(null),
        updatedAt: Value(acquiredAt),
      ),
    );
  }

  Future<String> _upsertIncomingQueueRecord({
    required String packageId,
    required String localPath,
    required String status,
  }) async {
    final existing = await (_db.select(_db.syncQueue)
          ..where(
            (tbl) =>
                tbl.direction.equals('incoming') &
                tbl.packageType.equals('inspection_result') &
                tbl.packageId.equals(packageId),
          )
          ..limit(1))
        .getSingleOrNull();
    final now = nowIso();
    if (existing == null) {
      final id = generateId('queue');
      await _db.into(_db.syncQueue).insert(
            SyncQueueCompanion.insert(
              id: id,
              direction: 'incoming',
              packageType: 'inspection_result',
              packageId: packageId,
              localPath: localPath,
              status: status,
              createdAt: now,
              updatedAt: now,
            ),
          );
      return id;
    }

    await (_db.update(_db.syncQueue)..where((tbl) => tbl.id.equals(existing.id))).write(
      SyncQueueCompanion(
        localPath: Value(localPath),
        status: Value(status),
        updatedAt: Value(now),
      ),
    );
    return existing.id;
  }

  Future<void> _updateIncomingQueueStatus({
    required String queueId,
    required String status,
    String? lastError,
    String? localPath,
  }) async {
    await (_db.update(_db.syncQueue)..where((tbl) => tbl.id.equals(queueId))).write(
      SyncQueueCompanion(
        status: Value(status),
        localPath: localPath == null ? const Value.absent() : Value(localPath),
        lastError: Value(lastError),
        nextAttemptAt: const Value(null),
        updatedAt: Value(nowIso()),
      ),
    );
  }

  Future<void> _markQueueProcessing(String queueId) async {
    await (_db.update(_db.syncQueue)..where((tbl) => tbl.id.equals(queueId))).write(
      SyncQueueCompanion(
        status: const Value('processing'),
        nextAttemptAt: const Value(null),
        updatedAt: Value(nowIso()),
      ),
    );
  }

  Future<void> _markQueueDone(String queueId) async {
    await (_db.update(_db.syncQueue)..where((tbl) => tbl.id.equals(queueId))).write(
      SyncQueueCompanion(
        status: const Value('done'),
        lastError: const Value(null),
        nextAttemptAt: const Value(null),
        updatedAt: Value(nowIso()),
      ),
    );
  }

  Future<void> _markQueueFailed(
    String queueId,
    String error, {
    String? localPath,
  }) async {
    final existing = await (_db.select(_db.syncQueue)
          ..where((tbl) => tbl.id.equals(queueId)))
        .getSingle();
    final nextAttemptCount = existing.attemptCount + 1;
    final nextAttemptAt = DateTime.now()
        .toUtc()
        .add(_retryDelayForAttempt(nextAttemptCount))
        .toIso8601String();
    await (_db.update(_db.syncQueue)..where((tbl) => tbl.id.equals(queueId))).write(
      SyncQueueCompanion(
        status: const Value('failed'),
        localPath: localPath == null ? const Value.absent() : Value(localPath),
        lastError: Value(error),
        attemptCount: Value(nextAttemptCount),
        nextAttemptAt: Value(nextAttemptAt),
        updatedAt: Value(nowIso()),
      ),
    );
  }

  Future<void> _storeConflictInspection({
    required Map<String, dynamic> inspectionPayload,
    required String conflictReason,
  }) async {
    final inspectionId = _readRequiredString(inspectionPayload, 'id');
    final existing = await (_db.select(_db.inspections)
          ..where((tbl) => tbl.id.equals(inspectionId)))
        .getSingleOrNull();
    if (existing != null) {
      return;
    }

    await _db.into(_db.inspections).insert(
          InspectionsCompanion.insert(
            id: inspectionId,
            deviceId: _readRequiredString(inspectionPayload, 'device_id'),
            userId: _readRequiredString(inspectionPayload, 'user_id'),
            productObjectId: _readRequiredString(
              inspectionPayload,
              'product_object_id',
            ),
            targetObjectId: _readRequiredString(
              inspectionPayload,
              'target_object_id',
            ),
            startedAt: _readRequiredString(inspectionPayload, 'started_at'),
            completedAt: driftValue(
              nullableField(inspectionPayload['completed_at']?.toString()),
            ),
            status: 'conflict',
            syncStatus: 'conflict',
            sourceReferencePackageId: driftValue(
              nullableField(inspectionPayload['source_reference_package_id']?.toString()),
            ),
            sourceReferenceVersion: driftValue(
              nullableField(inspectionPayload['source_reference_version']?.toString()),
            ),
            conflictReason: Value(conflictReason),
            createdAt: _readRequiredString(inspectionPayload, 'created_at'),
            updatedAt: nowIso(),
          ),
        );
  }

  Future<List<InspectionSignaturesCompanion>> _copyImportedSignatures({
    required String inspectionId,
    required List<Map<String, dynamic>> signaturesPayload,
    required Directory extractDir,
  }) async {
    final imported = <InspectionSignaturesCompanion>[];
    for (final row in signaturesPayload) {
      final relativeSource = _readRequiredString(row, 'image_local_path');
      final source = File(
        p.join(extractDir.path, relativeSource.replaceAll('/', p.separator)),
      );
      if (!await source.exists()) {
        continue;
      }
      final fileName = p.basename(source.path);
      final destination = File(
        p.join(_paths.signaturesDir.path, inspectionId, fileName),
      );
      await destination.parent.create(recursive: true);
      await source.copy(destination.path);
      imported.add(
        InspectionSignaturesCompanion.insert(
          id: _readRequiredString(row, 'id'),
          inspectionId: inspectionId,
          signerUserId: driftValue(nullableField(row['signer_user_id']?.toString())),
          signerName: _readRequiredString(row, 'signer_name'),
          signerRole: _readRequiredString(row, 'signer_role'),
          imageLocalPath: _paths.relativeToRoot(destination.path),
          checksum: _readRequiredString(row, 'checksum'),
          signedAt: _readRequiredString(row, 'signed_at'),
          createdAt: nowIso(),
          updatedAt: nowIso(),
        ),
      );
    }
    return imported;
  }

  Future<InspectionPdfInfo?> _copyImportedPdf({
    required String inspectionId,
    required List<Map<String, dynamic>> filesPayload,
    required Directory extractDir,
  }) async {
    final pdfRow = filesPayload.firstWhere(
      (row) => row['file_type']?.toString() == 'pdf',
      orElse: () => const <String, dynamic>{},
    );
    if (pdfRow.isEmpty) {
      return null;
    }

    final relativeSource = nullableField(pdfRow['local_path']?.toString());
    if (relativeSource == null) {
      return null;
    }
    final source = File(
      p.join(extractDir.path, relativeSource.replaceAll('/', p.separator)),
    );
    if (!await source.exists()) {
      return null;
    }

    final fileName = p.basename(source.path);
    final destination = File(p.join(_paths.reportsDir.path, inspectionId, fileName));
    await destination.parent.create(recursive: true);
    await source.copy(destination.path);

    return InspectionPdfInfo(
      relativePath: _paths.relativeToRoot(destination.path),
      absolutePath: destination.path,
      checksum: _readRequiredString(pdfRow, 'checksum'),
    );
  }

  Future<void> _recordSyncFailure({
    required String operation,
    required Object error,
    required StackTrace stackTrace,
    String? actorUserId,
    String? entityId,
  }) async {
    _logger.error(operation, error, stackTrace);
    await _upsertSyncState(
      lastError: error.toString(),
      updatedAt: nowIso(),
    );
    await _markConnectivity(false);
    await recordAudit(
      _db,
      actionType: operation,
      resultStatus: 'error',
      userId: actorUserId,
      entityType: entityId == null ? null : 'sync_package',
      entityId: entityId,
      message: error.toString(),
    );
  }

  Future<void> _markSyncSuccess() async {
    await _markConnectivity(true);
    await _upsertSyncState(
      lastSuccessAt: nowIso(),
      lastError: null,
    );
  }

  Future<void> _markSyncPartial(String message) async {
    final now = nowIso();
    await _markConnectivity(true);
    await _upsertSyncState(
      lastSuccessAt: now,
      lastError: message,
      updatedAt: now,
    );
  }

  Future<void> _runBestEffortAndroidSync({
    required String actorUserId,
  }) async {
    if (!await _transport.isConfigured()) {
      return;
    }
    try {
      await runManualSync(
        platform: AppPlatform.android,
        actorUserId: actorUserId,
      );
    } catch (error, stackTrace) {
      _logger.warning('Best-effort Android sync skipped: $error');
      _logger.error('sync.best_effort', error, stackTrace);
    }
  }

  Future<void> _markConnectivity(bool isConnected) async {
    final device = await _db.select(_db.deviceInfo).getSingleOrNull();
    if (device == null) {
      return;
    }
    final now = nowIso();
    await (_db.update(_db.deviceInfo)..where((tbl) => tbl.id.equals(device.id))).write(
      DeviceInfoCompanion(
        lastSyncAt: Value(now),
        yandexDiskConnected: Value(isConnected),
        updatedAt: Value(now),
      ),
    );
  }

  Future<SyncStateData?> _loadSyncState() {
    return (_db.select(_db.syncState)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> _upsertSyncState({
    String? lastReferencePackageId,
    String? lastReferenceSyncAt,
    String? lastResultPushAt,
    String? lastResultPullAt,
    String? lastSuccessAt,
    String? lastError,
    String? updatedAt,
  }) async {
    final device = await _db.select(_db.deviceInfo).getSingleOrNull();
    final deviceId = device?.id ?? AppConstants.defaultDeviceId;
    final existing = await _loadSyncState();
    final now = updatedAt ?? nowIso();

    await _db.into(_db.syncState).insertOnConflictUpdate(
          SyncStateCompanion(
            id: Value(existing?.id ?? '$deviceId-sync-state'),
            deviceId: Value(deviceId),
            lastReferencePackageId: lastReferencePackageId == null
                ? Value(existing?.lastReferencePackageId)
                : Value(lastReferencePackageId),
            lastReferenceSyncAt: lastReferenceSyncAt == null
                ? Value(existing?.lastReferenceSyncAt)
                : Value(lastReferenceSyncAt),
            lastResultPushAt: lastResultPushAt == null
                ? Value(existing?.lastResultPushAt)
                : Value(lastResultPushAt),
            lastResultPullAt: lastResultPullAt == null
                ? Value(existing?.lastResultPullAt)
                : Value(lastResultPullAt),
            lastSuccessAt: lastSuccessAt == null
                ? Value(existing?.lastSuccessAt)
                : Value(lastSuccessAt),
            lastError: Value(lastError),
            schemaVersion: Value(existing?.schemaVersion ?? AppConstants.syncSchemaVersion),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> _ensureConfiguredTransport() async {
    if (!await _transport.isConfigured()) {
      throw const SyncTransportException('Yandex Disk token is not configured.');
    }
  }

  Future<void> _ensureManualSyncAllowed({
    required AppPlatform platform,
    required String? actorUserId,
  }) async {
    final capability = switch (platform) {
      AppPlatform.windows => AppCapability.manageSync,
      AppPlatform.android => AppCapability.runSync,
      AppPlatform.unsupported => AppCapability.runSync,
    };
    final deniedMessage = switch (platform) {
      AppPlatform.windows => 'Только администратор может запускать синхронизацию Windows.',
      AppPlatform.android => 'Эта роль не может запускать синхронизацию Android.',
      AppPlatform.unsupported => 'Синхронизация не поддерживается на этой платформе.',
    };
    await requireUserCapability(
      _db,
      actorUserId: actorUserId,
      capability: capability,
      deniedMessage: deniedMessage,
    );
  }

  Future<bool> _canRunSyncAutomatically({
    required AppPlatform platform,
    required String actorUserId,
  }) async {
    final capability = switch (platform) {
      AppPlatform.windows => AppCapability.manageSync,
      AppPlatform.android => AppCapability.runSync,
      AppPlatform.unsupported => AppCapability.runSync,
    };
    final roleCode = await loadUserRoleCode(_db, actorUserId);
    return roleHasCapability(roleCode, capability);
  }

  Future<List<SyncQueueData>> _loadOutgoingPackagesForRun({
    required String packageType,
    required bool respectRetrySchedule,
  }) async {
    final candidates = await (_db.select(_db.syncQueue)
          ..where(
            (tbl) =>
                tbl.direction.equals('outgoing') &
                tbl.packageType.equals(packageType) &
                (tbl.status.equals('pending') | tbl.status.equals('failed')),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
    return candidates
        .where(
          (entry) => _shouldProcessQueueEntry(
            entry,
            respectRetrySchedule: respectRetrySchedule,
          ),
        )
        .toList(growable: false);
  }

  bool _shouldProcessQueueEntry(
    SyncQueueData? entry, {
    required bool respectRetrySchedule,
  }) {
    if (entry == null) {
      return true;
    }
    if (entry.status == 'pending') {
      return true;
    }
    if (entry.status != 'failed') {
      return false;
    }
    if (!respectRetrySchedule) {
      return true;
    }
    final nextAttemptAt = nullableField(entry.nextAttemptAt);
    if (nextAttemptAt == null) {
      return true;
    }
    final retryAt = DateTime.tryParse(nextAttemptAt);
    return retryAt == null || !retryAt.isAfter(DateTime.now().toUtc());
  }

  Expression<bool> _retryEligibleQueueExpression(
    SyncQueue table,
    String now,
  ) {
    return table.status.equals('failed') &
        (table.nextAttemptAt.isNull() |
            table.nextAttemptAt.isSmallerOrEqualValue(now));
  }

  Future<int> _countRetryEligibleEntries() async {
    final expression = _db.syncQueue.id.count();
    final result = await (_db.selectOnly(_db.syncQueue)
          ..addColumns([expression])
          ..where(_retryEligibleQueueExpression(_db.syncQueue, nowIso())))
        .getSingle();
    return result.read(expression) ?? 0;
  }

  Duration _retryDelayForAttempt(int attemptCount) {
    if (attemptCount <= 1) {
      return const Duration(seconds: 30);
    }
    if (attemptCount == 2) {
      return const Duration(minutes: 2);
    }
    if (attemptCount == 3) {
      return const Duration(minutes: 5);
    }
    return const Duration(minutes: 15);
  }

  Future<Map<String, dynamic>> _readJsonFile(File file) async {
    final raw = await file.readAsString();
    final payload = jsonDecode(raw);
    if (payload is! Map<String, dynamic>) {
      throw StateError('Expected JSON object in ${file.path}.');
    }
    return payload;
  }

  Future<List<Map<String, dynamic>>> _readJsonList(File file) async {
    final raw = await file.readAsString();
    final payload = jsonDecode(raw);
    return _mapList(payload).toList(growable: false);
  }

  Iterable<Map<String, dynamic>> _mapList(Object? payload) sync* {
    if (payload is! List) {
      return;
    }
    for (final item in payload) {
      if (item is Map<String, dynamic>) {
        yield item;
      } else if (item is Map) {
        yield item.map((key, value) => MapEntry(key.toString(), value));
      }
    }
  }

  String _readRequiredString(Map<String, dynamic> row, String key) {
    final value = nullableField(row[key]?.toString());
    if (value == null) {
      throw StateError('Missing required field "$key".');
    }
    return value;
  }

  int _readInt(Object? value, {int defaultValue = 0}) {
    if (value == null) {
      return defaultValue;
    }
    if (value is int) {
      return value;
    }
    return int.tryParse(value.toString()) ?? defaultValue;
  }

  bool _readBool(Object? value, {bool defaultValue = false}) {
    if (value == null) {
      return defaultValue;
    }
    if (value is bool) {
      return value;
    }
    final normalized = value.toString().trim().toLowerCase();
    return normalized == '1' || normalized == 'true';
  }
}
