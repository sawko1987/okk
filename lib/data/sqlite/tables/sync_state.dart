import 'package:drift/drift.dart';

class SyncState extends Table {
  TextColumn get id => text()();
  TextColumn get deviceId => text()();
  TextColumn get lastReferencePackageId => text().nullable()();
  TextColumn get lastReferenceSyncAt => text().nullable()();
  TextColumn get lastResultPushAt => text().nullable()();
  TextColumn get lastResultPullAt => text().nullable()();
  TextColumn get lastSuccessAt => text().nullable()();
  TextColumn get lastError => text().nullable()();
  TextColumn get schemaVersion => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
