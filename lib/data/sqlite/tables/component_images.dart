import 'package:drift/drift.dart';

class ComponentImages extends Table {
  TextColumn get id => text()();
  TextColumn get componentId => text()();
  TextColumn get fileName => text()();
  TextColumn get mediaKey => text()();
  TextColumn get localPath => text().nullable()();
  TextColumn get remotePath => text().nullable()();
  TextColumn get checksum => text()();
  TextColumn get mimeType => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
