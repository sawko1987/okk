import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:okk_qc_app/core/logging/app_logger.dart';
import 'package:okk_qc_app/core/storage/app_paths.dart';
import 'package:okk_qc_app/data/sqlite/app_database.dart';
import 'package:okk_qc_app/data/sync/package_archive.dart';
import 'package:okk_qc_app/data/sync/sync_service.dart';
import 'package:okk_qc_app/data/sync/yandex_disk_transport.dart';
import 'package:okk_qc_app/features/admin/data/admin_repositories.dart';
import 'package:okk_qc_app/features/auth/data/auth_service.dart';
import 'package:okk_qc_app/features/inspections/data/inspection_repositories.dart';
import 'package:okk_qc_app/features/inspections/presentation/android_workflow_screens.dart';
import 'package:path/path.dart' as p;

void main() {
  late _TestHarness harness;

  setUp(() async {
    harness = await _TestHarness.create();
  });

  tearDown(() async {
    await harness.dispose();
  });

  testWidgets(
    'Android mode screen shows read-only restrictions and missing sync prerequisites',
    (tester) async {
      await _pumpAndroidScreen(
        tester,
        const AndroidModeScreen(),
        overrides: [
          syncServiceProvider.overrideWithValue(harness.syncService),
          activeSessionProvider.overrideWith(
            (ref) async => const AuthSession(
              userId: 'viewer-1',
              fullName: 'Viewer User',
              roleId: 'role-viewer',
              roleCode: 'viewer',
              roleName: 'Viewer',
            ),
          ),
          inspectionWorkshopsProvider.overrideWith((ref) async => const []),
          androidInspectionDiagnosticsProvider.overrideWith(
            (ref) async => const AndroidInspectionDiagnostics(
              localDraftCount: 0,
              queuedResultCount: 1,
              failedQueueCount: 1,
              retryEligibleCount: 1,
              conflictCount: 0,
              lastReferencePackageId: null,
              lastReferenceSyncAt: null,
              lastSyncAttemptAt: '2026-03-19T09:00:00Z',
              lastRetryAt: '2026-03-19T09:10:00Z',
              lastCompletedInspectionAt: null,
            ),
          ),
          syncDiagnosticsProvider.overrideWith(
            (ref) async => const SyncDiagnosticsSnapshot(
              deviceId: 'android-test-device',
              lastReferencePackageId: null,
              lastReferenceSyncAt: null,
              lastResultPushAt: null,
              lastResultPullAt: null,
              lastSuccessAt: null,
              lastSyncAttemptAt: '2026-03-19T09:00:00Z',
              lastRetryAt: '2026-03-19T09:10:00Z',
              lastConflictAt: null,
              lastError: 'Token missing',
              pendingOutgoingCount: 1,
              pendingIncomingCount: 0,
              failedQueueCount: 1,
              retryEligibleCount: 1,
              conflictCount: 0,
              transportConfigured: false,
              yandexDiskConnected: false,
            ),
          ),
        ],
      );

      expect(find.text('This role cannot create or edit inspections.'), findsOneWidget);
      expect(
        find.text('Open completed, queued, synced, or conflict results.'),
        findsOneWidget,
      );
      expect(find.text('Reference data is not ready'), findsOneWidget);
      expect(find.text('Yandex Disk token is not configured'), findsOneWidget);
    },
  );

  testWidgets(
    'Android sync screen surfaces pending work and missing token guidance',
    (tester) async {
      await _pumpAndroidScreen(
        tester,
        const AndroidSyncScreen(),
        overrides: [
          syncServiceProvider.overrideWithValue(harness.syncService),
          activeSessionProvider.overrideWith(
            (ref) async => const AuthSession(
              userId: 'worker-1',
              fullName: 'Worker User',
              roleId: 'role-worker',
              roleCode: 'worker',
              roleName: 'Worker',
            ),
          ),
          androidInspectionDiagnosticsProvider.overrideWith(
            (ref) async => const AndroidInspectionDiagnostics(
              localDraftCount: 2,
              queuedResultCount: 1,
              failedQueueCount: 1,
              retryEligibleCount: 1,
              conflictCount: 0,
              lastReferencePackageId: null,
              lastReferenceSyncAt: null,
              lastSyncAttemptAt: '2026-03-19T09:00:00Z',
              lastRetryAt: '2026-03-19T09:10:00Z',
              lastCompletedInspectionAt: '2026-03-19T08:30:00Z',
            ),
          ),
          syncDiagnosticsProvider.overrideWith(
            (ref) async => const SyncDiagnosticsSnapshot(
              deviceId: 'android-test-device',
              lastReferencePackageId: null,
              lastReferenceSyncAt: null,
              lastResultPushAt: null,
              lastResultPullAt: null,
              lastSuccessAt: null,
              lastSyncAttemptAt: '2026-03-19T09:00:00Z',
              lastRetryAt: '2026-03-19T09:10:00Z',
              lastConflictAt: null,
              lastError: 'Token missing',
              pendingOutgoingCount: 1,
              pendingIncomingCount: 0,
              failedQueueCount: 1,
              retryEligibleCount: 1,
              conflictCount: 0,
              transportConfigured: false,
              yandexDiskConnected: false,
            ),
          ),
        ],
      );

      expect(find.text('Sync now'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Diagnostics'), findsOneWidget);
      expect(find.text('Pending local sync work'), findsOneWidget);
      expect(find.text('Yandex Disk token is missing'), findsOneWidget);
    },
  );

  testWidgets(
    'Android drafts screen shows a route back to the inspection flow when empty',
    (tester) async {
      await _pumpAndroidScreen(
        tester,
        const AndroidDraftsScreen(),
        overrides: [
          syncServiceProvider.overrideWithValue(harness.syncService),
          activeSessionProvider.overrideWith(
            (ref) async => const AuthSession(
              userId: 'worker-1',
              fullName: 'Worker User',
              roleId: 'role-worker',
              roleCode: 'worker',
              roleName: 'Worker',
            ),
          ),
          inspectionDraftsProvider.overrideWith((ref, userId) async => const []),
        ],
      );

      expect(find.text('No draft inspections yet'), findsOneWidget);
      expect(find.text('Open inspection flow'), findsOneWidget);
    },
  );
}

Future<void> _pumpAndroidScreen(
  WidgetTester tester,
  Widget child, {
  required List<Override> overrides,
}) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => child,
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

class _TestHarness {
  _TestHarness({
    required this.tempDir,
    required this.database,
    required this.syncService,
  });

  final Directory tempDir;
  final AppDatabase database;
  final SyncService syncService;

  static Future<_TestHarness> create() async {
    final tempDir = await Directory.systemTemp.createTemp(
      'okk-android-workflow-test-',
    );
    final paths = AppPaths.forTesting(p.join(tempDir.path, 'app_data'));
    await paths.ensureCreated();

    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.ensureBootstrapData(
      deviceId: 'android-test-device',
      deviceName: 'android-test-host',
      platform: 'android',
      appVersion: '1.0.0+1',
      rootPath: paths.rootDir.path,
    );

    final syncService = SyncService(
      db: database,
      paths: paths,
      logger: AppLogger(),
      transport: _DisabledSyncTransport(),
      packageArchive: PackageArchive(),
      referencePackageRepository: ReferencePackageRepository(database, paths),
      inspectionsRepository: InspectionsRepository(database, paths),
    );

    return _TestHarness(
      tempDir: tempDir,
      database: database,
      syncService: syncService,
    );
  }

  Future<void> dispose() async {
    await database.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  }
}

class _DisabledSyncTransport implements SyncTransport {
  @override
  Future<void> deletePath(String remotePath) async {}

  @override
  Future<File> downloadFile({
    required String remotePath,
    required File destinationFile,
  }) {
    throw StateError('Sync transport is disabled in widget tests.');
  }

  @override
  Future<String?> downloadString(String remotePath) async => null;

  @override
  Future<void> ensureRemoteLayout() async {}

  @override
  Future<bool> isConfigured() async => false;

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
