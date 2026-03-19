import 'package:drift/drift.dart';

class Inspections extends Table {
  TextColumn get id => text()();
  TextColumn get deviceId => text()();
  TextColumn get userId => text()();
  TextColumn get productObjectId => text()();
  TextColumn get targetObjectId => text()();
  TextColumn get startedAt => text()();
  TextColumn get completedAt => text().nullable()();
  TextColumn get status => text()();
  TextColumn get syncStatus => text()();
  TextColumn get sourceReferencePackageId => text().nullable()();
  TextColumn get sourceReferenceVersion => text().nullable()();
  TextColumn get pdfLocalPath => text().nullable()();
  TextColumn get pdfChecksum => text().nullable()();
  TextColumn get conflictReason => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
