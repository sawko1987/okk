import 'package:drift/drift.dart';

class Sections extends Table {
  TextColumn get id => text()();
  TextColumn get workshopId => text()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
