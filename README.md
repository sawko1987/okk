# OKK QC App

Local-first Flutter application for Windows administration and Android quality inspections.

## Current Stage

The repository is in foundation stage completion:

- Flutter app scaffolded for Windows and Android
- local storage layout under `app_data/`
- Drift-based SQLite bootstrap
- base routing and platform shells
- diagnostics and settings stubs

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
