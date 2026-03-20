# OKK QC App

Local-first Flutter application for Windows administration and Android quality inspections.

## Current Stage

The repository is now beyond foundation and spans Stage 3 Windows master-data, Stage 4A Android inspection completion, and Stage 5 Sync v1:

- Flutter app scaffolded for Windows and Android
- Drift-based SQLite bootstrap with schema v5
- local storage layout under `app_data/`
- local login/session flow with seeded default administrator
- Windows admin sections for structure, objects, components, checklists, users, roles, audit, trash, and sync/export
- Windows role review now shows the fixed v1 permission matrix, assigned users, and capability summaries for each role
- component image import into local `media/components`
- local reference package export into `sync/outgoing`
- Android route-based workflow with explicit mode, workshop, product, target, component, drafts, results, sync, settings, and diagnostics screens
- Android workspace UX now surfaces role restrictions, missing reference data, pending sync work, and missing token prerequisites directly on-device
- Android draft/result workflow with product-target selection, draft answers, local signatures, PDF generation, and queued result packages
- Sync v1 orchestration with startup/manual sync, Yandex Disk transport, remote package upload/download, reference import on Android, result import on Windows, basic remote product locks, and best-effort Android pre/post sync around inspections
- automatic retry-aware sync scheduling with queue backoff and app-resume retry entrypoints
- expanded diagnostics for pending/failed/conflict sync states on Windows and Android, including retry visibility
- audit log, settings, and trash recovery screens
- admin-only repository guards enforce user and catalog management even if a non-admin reaches a write path directly

Detailed scope and implementation phases are documented in:

- `FLUTTER_LOCAL_FIRST_TECHNICAL_SPECIFICATION.md`
- `DEVELOPMENT_CHECKLIST.md`
- `docs/STAGE_1_FOUNDATION_ARCHITECTURE.md`
- `docs/DATA_AND_SYNC_CONTRACT.md`

## Requirements

- Flutter SDK compatible with Dart `^3.10.8`
- Windows toolchain for `flutter build windows`
- Visual Studio C++ workload with ATL headers, required by `flutter_secure_storage_windows`
- Android SDK/JDK for `flutter build apk --release`
- Valid `JAVA_HOME` pointing to an installed JDK for Android release builds

## Localization

- The application must be fully Russian-language for end users.
- All UI text, operator/admin messages, dialogs, hints, diagnostics shown to users, and generated PDF labels should be written in Russian.
- English should be limited to source code, package names, file names, protocol fields, and other technical internals that are not exposed in the product UI.

## Development Commands

Run from the repository root:

```bash
flutter pub get
flutter analyze
flutter test
flutter build windows
flutter build apk --release
```

Useful platform runs:

```bash
flutter run -d windows
flutter run -d android
```

## Storage Model

The application creates a local `app_data/` root with these directories:

- `db/`
- `media/components/`
- `media/signatures/`
- `media/reports/`
- `sync/incoming/`
- `sync/outgoing/`
- `sync/processed/`
- `sync/temp/`
- `cache/images/`
- `logs/`

SQLite stores relative media/report paths; absolute filesystem paths are resolved from `app_data/` at runtime.

Completed Android inspections additionally write:

- signature images under `media/signatures/<inspection-id>/`
- generated PDFs under `media/reports/<inspection-id>/`
- local result packages under `sync/outgoing/inspection_<inspection-id>/`

Published sync artifacts on Yandex Disk use the documented transport-only layout:

- `manifest/global_manifest.json`
- `reference_data/packages/reference_<package-id>.zip`
- `results/incoming/result_<package-id>.zip`
- `results/processed/`
- `results/conflicts/`
- `media/components/`
- `locks/`

## Verification

Current local verification status:

- `flutter analyze` passes
- `flutter test test/app_database_test.dart` passes
- `flutter test test/app_permissions_test.dart` passes
- `flutter test test/users_repository_permissions_test.dart` covers admin-only user management
- focused sync hardening coverage was added in `test/sync_retry_policy_test.dart`
- Android route/state widget coverage was added in `test/android_workflow_screens_test.dart`
- inspection/sync tests need follow-up verification because `flutter test` currently hangs when loading the inspection modules in this environment
