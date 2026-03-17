import 'package:drift/drift.dart';

class ChecklistBindings extends Table {
  @override
  String get tableName => 'checklist_bindings';

  TextColumn get id => text()();
  TextColumn get checklistId => text()();
  TextColumn get targetType => text()();
  TextColumn get targetId => text().nullable()();
  TextColumn get targetObjectType => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  BoolColumn get isRequired => boolean().withDefault(const Constant(true))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
