import 'package:drift/drift.dart';

class AuditLog extends Table {
  @override
  String get tableName => 'audit_log';

  TextColumn get id => text()();
  TextColumn get happenedAt => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get deviceId => text().nullable()();
  TextColumn get actionType => text()();
  TextColumn get entityType => text().nullable()();
  TextColumn get entityId => text().nullable()();
  TextColumn get resultStatus => text()();
  TextColumn get message => text().nullable()();
  TextColumn get payloadJson => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
