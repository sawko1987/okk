import 'package:drift/drift.dart';

class InspectionSignatures extends Table {
  TextColumn get id => text()();
  TextColumn get inspectionId => text()();
  TextColumn get signerUserId => text().nullable()();
  TextColumn get signerName => text()();
  TextColumn get signerRole => text()();
  TextColumn get imageLocalPath => text()();
  TextColumn get checksum => text()();
  TextColumn get signedAt => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
