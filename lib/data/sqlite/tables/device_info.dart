import 'package:drift/drift.dart';

class DeviceInfo extends Table {
  TextColumn get id => text()();
  TextColumn get deviceName => text()();
  TextColumn get platform => text()();
  TextColumn get appVersion => text()();
  TextColumn get dbSchemaVersion => text()();
  TextColumn get syncSchemaVersion => text()();
  TextColumn get rootPath => text()();
  TextColumn get lastSyncAt => text().nullable()();
  BoolColumn get yandexDiskConnected =>
      boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
