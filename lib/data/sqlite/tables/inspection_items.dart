import 'package:drift/drift.dart';

class InspectionItems extends Table {
  @override
  String get tableName => 'inspection_items';

  TextColumn get id => text()();
  TextColumn get inspectionId => text()();
  TextColumn get checklistItemId => text()();
  TextColumn get componentId => text().nullable()();
  TextColumn get resultStatus => text().withDefault(const Constant('not_checked'))();
  TextColumn get comment => text().nullable()();
  TextColumn get measuredValue => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
