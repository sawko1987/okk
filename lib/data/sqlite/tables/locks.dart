import 'package:drift/drift.dart';

class Locks extends Table {
  TextColumn get id => text()();
  TextColumn get productObjectId => text()();
  TextColumn get remoteLockKey => text()();
  TextColumn get deviceId => text()();
  TextColumn get userId => text()();
  TextColumn get status => text()();
  TextColumn get acquiredAt => text()();
  TextColumn get expiresAt => text()();
  TextColumn get releasedAt => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
