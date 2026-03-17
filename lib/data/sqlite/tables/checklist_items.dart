import 'package:drift/drift.dart';

class ChecklistItems extends Table {
  @override
  String get tableName => 'checklist_items';

  TextColumn get id => text()();
  TextColumn get checklistId => text()();
  TextColumn get componentId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get expectedResult => text().nullable()();
  TextColumn get resultType =>
      text().withDefault(const Constant('pass_fail_na'))();
  BoolColumn get isRequired => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
