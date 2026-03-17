import 'package:drift/drift.dart';

class Components extends Table {
  TextColumn get id => text()();
  TextColumn get objectId => text()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isRequired => boolean().withDefault(const Constant(true))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
