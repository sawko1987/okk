import 'package:drift/drift.dart';

class TrashBin extends Table {
  @override
  String get tableName => 'trash_bin';

  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get displayName => text()();
  TextColumn get snapshotJson => text()();
  TextColumn get deletedByUserId => text().nullable()();
  TextColumn get deletedAt => text()();
  TextColumn get restoredAt => text().nullable()();
  TextColumn get permanentlyDeletedAt => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
