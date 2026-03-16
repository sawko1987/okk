# Repository Guidelines

## Project Structure & Module Organization
This repository currently contains the product specification in `FLUTTER_LOCAL_FIRST_TECHNICAL_SPECIFICATION.md`. Application code has not been scaffolded yet. When implementation starts, keep a single Flutter codebase at the repo root and use standard platform folders: `lib/`, `test/`, `integration_test/`, `android/`, `windows/`, and `assets/`.

Organize `lib/` by feature and layer so Windows admin flows and Android inspection flows stay isolated. Example:
`lib/features/catalog/`, `lib/features/checklists/`, `lib/features/sync/`, `lib/data/sqlite/`, `lib/data/yandex_disk/`, `lib/ui/`.

## Build, Test, and Development Commands
Use Flutter tooling from the repository root once the app is created:

- `flutter pub get` installs dependencies.
- `flutter analyze` runs static analysis.
- `flutter test` runs unit and widget tests.
- `flutter test integration_test` runs integration coverage for sync, offline mode, and PDF flows.
- `flutter run -d windows` launches the Windows admin app locally.
- `flutter run -d android` launches the Android client on a device or emulator.
- `flutter build windows` and `flutter build apk --release` produce deliverables required by the specification.

## Coding Style & Naming Conventions
Follow Dart defaults: 2-space indentation, trailing commas in multiline widgets, and one public type per file where practical. Use `snake_case.dart` for files, `PascalCase` for classes, `camelCase` for methods and fields, and suffix state-management files consistently, for example `inspection_controller.dart` and `inspection_state.dart`.

Run `dart format .` before submitting changes. Treat analyzer warnings as blockers.

## Testing Guidelines
Prefer fast unit tests for SQLite repositories, sync packaging, and validation rules; add widget tests for critical screens; reserve integration tests for Windows/Android flows. Name tests after behavior, for example `sync_service_test.dart` or `checklist_submission_widget_test.dart`.

Cover offline-first behavior, conflict handling, backup/restore, and PDF generation before merging.

## Commit & Pull Request Guidelines
There is no git history in this workspace yet, so no repository-specific commit convention can be inferred. Start with short imperative subjects such as `Add SQLite sync queue` or `Implement Windows checklist editor`.

Each pull request should include scope, affected platform (`windows`, `android`, or `shared`), test evidence, and screenshots for UI changes. Link the relevant requirement section from `FLUTTER_LOCAL_FIRST_TECHNICAL_SPECIFICATION.md` when applicable.

## Security & Configuration Notes
Do not commit real Yandex Disk credentials, production SQLite files, generated PDFs, or user media. Keep local test data under a separate non-production path and document any required environment variables in the PR.
