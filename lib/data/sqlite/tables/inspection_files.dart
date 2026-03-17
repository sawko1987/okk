import 'package:drift/drift.dart';

class InspectionFiles extends Table {
  TextColumn get id => text()();
  TextColumn get inspectionId => text()();
  TextColumn get fileType => text()();
  TextColumn get fileName => text()();
  TextColumn get localPath => text()();
  TextColumn get checksum => text()();
  TextColumn get mimeType => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
