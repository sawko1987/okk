import 'package:drift/drift.dart';

class ObjectRelations extends Table {
  @override
  String get tableName => 'object_relations';

  TextColumn get id => text()();
  TextColumn get parentObjectId => text()();
  TextColumn get childObjectId => text()();
  TextColumn get relationType =>
      text().withDefault(const Constant('contains'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {parentObjectId, childObjectId},
      ];
}
