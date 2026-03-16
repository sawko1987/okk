import 'package:drift/drift.dart';

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get valueJson => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
