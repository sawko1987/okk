// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RolesTable extends Roles with TableInfo<$RolesTable, Role> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    description,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Role> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Role map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Role(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RolesTable createAlias(String alias) {
    return $RolesTable(attachedDatabase, alias);
  }
}

class Role extends DataClass implements Insertable<Role> {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String createdAt;
  final String updatedAt;
  const Role({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  RolesCompanion toCompanion(bool nullToAbsent) {
    return RolesCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Role.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Role(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Role copyWith({
    String? id,
    String? code,
    String? name,
    Value<String?> description = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => Role(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Role copyWithCompanion(RolesCompanion data) {
    return Role(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Role(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Role &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RolesCompanion extends UpdateCompanion<Role> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const RolesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RolesCompanion.insert({
    required String id,
    required String code,
    required String name,
    this.description = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Role> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RolesCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return RolesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RolesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueJsonMeta = const VerificationMeta(
    'valueJson',
  );
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
    'value_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, valueJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(
        _valueJsonMeta,
        valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      valueJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String valueJson;
  final String updatedAt;
  const AppSetting({
    required this.key,
    required this.valueJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value_json'] = Variable<String>(valueJson);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      valueJson: Value(valueJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'valueJson': serializer.toJson<String>(valueJson),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? valueJson, String? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        valueJson: valueJson ?? this.valueJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, valueJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.valueJson == this.valueJson &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> valueJson;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String valueJson,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       valueJson = Value(valueJson),
       updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? valueJson,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (valueJson != null) 'value_json': valueJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? valueJson,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      valueJson: valueJson ?? this.valueJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _happenedAtMeta = const VerificationMeta(
    'happenedAt',
  );
  @override
  late final GeneratedColumn<String> happenedAt = GeneratedColumn<String>(
    'happened_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultStatusMeta = const VerificationMeta(
    'resultStatus',
  );
  @override
  late final GeneratedColumn<String> resultStatus = GeneratedColumn<String>(
    'result_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    happenedAt,
    userId,
    deviceId,
    actionType,
    entityType,
    entityId,
    resultStatus,
    message,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('happened_at')) {
      context.handle(
        _happenedAtMeta,
        happenedAt.isAcceptableOrUnknown(data['happened_at']!, _happenedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_happenedAtMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('result_status')) {
      context.handle(
        _resultStatusMeta,
        resultStatus.isAcceptableOrUnknown(
          data['result_status']!,
          _resultStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resultStatusMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      happenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}happened_at'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      ),
      resultStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_status'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      ),
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final String id;
  final String happenedAt;
  final String? userId;
  final String? deviceId;
  final String actionType;
  final String? entityType;
  final String? entityId;
  final String resultStatus;
  final String? message;
  final String? payloadJson;
  const AuditLogData({
    required this.id,
    required this.happenedAt,
    this.userId,
    this.deviceId,
    required this.actionType,
    this.entityType,
    this.entityId,
    required this.resultStatus,
    this.message,
    this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['happened_at'] = Variable<String>(happenedAt);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['result_status'] = Variable<String>(resultStatus);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || payloadJson != null) {
      map['payload_json'] = Variable<String>(payloadJson);
    }
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      happenedAt: Value(happenedAt),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      actionType: Value(actionType),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      resultStatus: Value(resultStatus),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      payloadJson: payloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadJson),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<String>(json['id']),
      happenedAt: serializer.fromJson<String>(json['happenedAt']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      actionType: serializer.fromJson<String>(json['actionType']),
      entityType: serializer.fromJson<String?>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      resultStatus: serializer.fromJson<String>(json['resultStatus']),
      message: serializer.fromJson<String?>(json['message']),
      payloadJson: serializer.fromJson<String?>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'happenedAt': serializer.toJson<String>(happenedAt),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'actionType': serializer.toJson<String>(actionType),
      'entityType': serializer.toJson<String?>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'resultStatus': serializer.toJson<String>(resultStatus),
      'message': serializer.toJson<String?>(message),
      'payloadJson': serializer.toJson<String?>(payloadJson),
    };
  }

  AuditLogData copyWith({
    String? id,
    String? happenedAt,
    Value<String?> userId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? actionType,
    Value<String?> entityType = const Value.absent(),
    Value<String?> entityId = const Value.absent(),
    String? resultStatus,
    Value<String?> message = const Value.absent(),
    Value<String?> payloadJson = const Value.absent(),
  }) => AuditLogData(
    id: id ?? this.id,
    happenedAt: happenedAt ?? this.happenedAt,
    userId: userId.present ? userId.value : this.userId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    actionType: actionType ?? this.actionType,
    entityType: entityType.present ? entityType.value : this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    resultStatus: resultStatus ?? this.resultStatus,
    message: message.present ? message.value : this.message,
    payloadJson: payloadJson.present ? payloadJson.value : this.payloadJson,
  );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      happenedAt: data.happenedAt.present
          ? data.happenedAt.value
          : this.happenedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      resultStatus: data.resultStatus.present
          ? data.resultStatus.value
          : this.resultStatus,
      message: data.message.present ? data.message.value : this.message,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('happenedAt: $happenedAt, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('actionType: $actionType, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('resultStatus: $resultStatus, ')
          ..write('message: $message, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    happenedAt,
    userId,
    deviceId,
    actionType,
    entityType,
    entityId,
    resultStatus,
    message,
    payloadJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.happenedAt == this.happenedAt &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.actionType == this.actionType &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.resultStatus == this.resultStatus &&
          other.message == this.message &&
          other.payloadJson == this.payloadJson);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<String> id;
  final Value<String> happenedAt;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<String> actionType;
  final Value<String?> entityType;
  final Value<String?> entityId;
  final Value<String> resultStatus;
  final Value<String?> message;
  final Value<String?> payloadJson;
  final Value<int> rowid;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.happenedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.actionType = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.resultStatus = const Value.absent(),
    this.message = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogCompanion.insert({
    required String id,
    required String happenedAt,
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String actionType,
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    required String resultStatus,
    this.message = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       happenedAt = Value(happenedAt),
       actionType = Value(actionType),
       resultStatus = Value(resultStatus);
  static Insertable<AuditLogData> custom({
    Expression<String>? id,
    Expression<String>? happenedAt,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<String>? actionType,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? resultStatus,
    Expression<String>? message,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (happenedAt != null) 'happened_at': happenedAt,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (actionType != null) 'action_type': actionType,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (resultStatus != null) 'result_status': resultStatus,
      if (message != null) 'message': message,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogCompanion copyWith({
    Value<String>? id,
    Value<String>? happenedAt,
    Value<String?>? userId,
    Value<String?>? deviceId,
    Value<String>? actionType,
    Value<String?>? entityType,
    Value<String?>? entityId,
    Value<String>? resultStatus,
    Value<String?>? message,
    Value<String?>? payloadJson,
    Value<int>? rowid,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      happenedAt: happenedAt ?? this.happenedAt,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      actionType: actionType ?? this.actionType,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      resultStatus: resultStatus ?? this.resultStatus,
      message: message ?? this.message,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (happenedAt.present) {
      map['happened_at'] = Variable<String>(happenedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (resultStatus.present) {
      map['result_status'] = Variable<String>(resultStatus.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('happenedAt: $happenedAt, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('actionType: $actionType, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('resultStatus: $resultStatus, ')
          ..write('message: $message, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceInfoTable extends DeviceInfo
    with TableInfo<$DeviceInfoTable, DeviceInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceInfoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceNameMeta = const VerificationMeta(
    'deviceName',
  );
  @override
  late final GeneratedColumn<String> deviceName = GeneratedColumn<String>(
    'device_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dbSchemaVersionMeta = const VerificationMeta(
    'dbSchemaVersion',
  );
  @override
  late final GeneratedColumn<String> dbSchemaVersion = GeneratedColumn<String>(
    'db_schema_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncSchemaVersionMeta = const VerificationMeta(
    'syncSchemaVersion',
  );
  @override
  late final GeneratedColumn<String> syncSchemaVersion =
      GeneratedColumn<String>(
        'sync_schema_version',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _rootPathMeta = const VerificationMeta(
    'rootPath',
  );
  @override
  late final GeneratedColumn<String> rootPath = GeneratedColumn<String>(
    'root_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<String> lastSyncAt = GeneratedColumn<String>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yandexDiskConnectedMeta =
      const VerificationMeta('yandexDiskConnected');
  @override
  late final GeneratedColumn<bool> yandexDiskConnected = GeneratedColumn<bool>(
    'yandex_disk_connected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("yandex_disk_connected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceName,
    platform,
    appVersion,
    dbSchemaVersion,
    syncSchemaVersion,
    rootPath,
    lastSyncAt,
    yandexDiskConnected,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_info';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceInfoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_name')) {
      context.handle(
        _deviceNameMeta,
        deviceName.isAcceptableOrUnknown(data['device_name']!, _deviceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceNameMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_appVersionMeta);
    }
    if (data.containsKey('db_schema_version')) {
      context.handle(
        _dbSchemaVersionMeta,
        dbSchemaVersion.isAcceptableOrUnknown(
          data['db_schema_version']!,
          _dbSchemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dbSchemaVersionMeta);
    }
    if (data.containsKey('sync_schema_version')) {
      context.handle(
        _syncSchemaVersionMeta,
        syncSchemaVersion.isAcceptableOrUnknown(
          data['sync_schema_version']!,
          _syncSchemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncSchemaVersionMeta);
    }
    if (data.containsKey('root_path')) {
      context.handle(
        _rootPathMeta,
        rootPath.isAcceptableOrUnknown(data['root_path']!, _rootPathMeta),
      );
    } else if (isInserting) {
      context.missing(_rootPathMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('yandex_disk_connected')) {
      context.handle(
        _yandexDiskConnectedMeta,
        yandexDiskConnected.isAcceptableOrUnknown(
          data['yandex_disk_connected']!,
          _yandexDiskConnectedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceInfoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_name'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
      dbSchemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}db_schema_version'],
      )!,
      syncSchemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_schema_version'],
      )!,
      rootPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_path'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_at'],
      ),
      yandexDiskConnected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}yandex_disk_connected'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DeviceInfoTable createAlias(String alias) {
    return $DeviceInfoTable(attachedDatabase, alias);
  }
}

class DeviceInfoData extends DataClass implements Insertable<DeviceInfoData> {
  final String id;
  final String deviceName;
  final String platform;
  final String appVersion;
  final String dbSchemaVersion;
  final String syncSchemaVersion;
  final String rootPath;
  final String? lastSyncAt;
  final bool yandexDiskConnected;
  final String createdAt;
  final String updatedAt;
  const DeviceInfoData({
    required this.id,
    required this.deviceName,
    required this.platform,
    required this.appVersion,
    required this.dbSchemaVersion,
    required this.syncSchemaVersion,
    required this.rootPath,
    this.lastSyncAt,
    required this.yandexDiskConnected,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_name'] = Variable<String>(deviceName);
    map['platform'] = Variable<String>(platform);
    map['app_version'] = Variable<String>(appVersion);
    map['db_schema_version'] = Variable<String>(dbSchemaVersion);
    map['sync_schema_version'] = Variable<String>(syncSchemaVersion);
    map['root_path'] = Variable<String>(rootPath);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<String>(lastSyncAt);
    }
    map['yandex_disk_connected'] = Variable<bool>(yandexDiskConnected);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  DeviceInfoCompanion toCompanion(bool nullToAbsent) {
    return DeviceInfoCompanion(
      id: Value(id),
      deviceName: Value(deviceName),
      platform: Value(platform),
      appVersion: Value(appVersion),
      dbSchemaVersion: Value(dbSchemaVersion),
      syncSchemaVersion: Value(syncSchemaVersion),
      rootPath: Value(rootPath),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      yandexDiskConnected: Value(yandexDiskConnected),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DeviceInfoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceInfoData(
      id: serializer.fromJson<String>(json['id']),
      deviceName: serializer.fromJson<String>(json['deviceName']),
      platform: serializer.fromJson<String>(json['platform']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
      dbSchemaVersion: serializer.fromJson<String>(json['dbSchemaVersion']),
      syncSchemaVersion: serializer.fromJson<String>(json['syncSchemaVersion']),
      rootPath: serializer.fromJson<String>(json['rootPath']),
      lastSyncAt: serializer.fromJson<String?>(json['lastSyncAt']),
      yandexDiskConnected: serializer.fromJson<bool>(
        json['yandexDiskConnected'],
      ),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceName': serializer.toJson<String>(deviceName),
      'platform': serializer.toJson<String>(platform),
      'appVersion': serializer.toJson<String>(appVersion),
      'dbSchemaVersion': serializer.toJson<String>(dbSchemaVersion),
      'syncSchemaVersion': serializer.toJson<String>(syncSchemaVersion),
      'rootPath': serializer.toJson<String>(rootPath),
      'lastSyncAt': serializer.toJson<String?>(lastSyncAt),
      'yandexDiskConnected': serializer.toJson<bool>(yandexDiskConnected),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  DeviceInfoData copyWith({
    String? id,
    String? deviceName,
    String? platform,
    String? appVersion,
    String? dbSchemaVersion,
    String? syncSchemaVersion,
    String? rootPath,
    Value<String?> lastSyncAt = const Value.absent(),
    bool? yandexDiskConnected,
    String? createdAt,
    String? updatedAt,
  }) => DeviceInfoData(
    id: id ?? this.id,
    deviceName: deviceName ?? this.deviceName,
    platform: platform ?? this.platform,
    appVersion: appVersion ?? this.appVersion,
    dbSchemaVersion: dbSchemaVersion ?? this.dbSchemaVersion,
    syncSchemaVersion: syncSchemaVersion ?? this.syncSchemaVersion,
    rootPath: rootPath ?? this.rootPath,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    yandexDiskConnected: yandexDiskConnected ?? this.yandexDiskConnected,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DeviceInfoData copyWithCompanion(DeviceInfoCompanion data) {
    return DeviceInfoData(
      id: data.id.present ? data.id.value : this.id,
      deviceName: data.deviceName.present
          ? data.deviceName.value
          : this.deviceName,
      platform: data.platform.present ? data.platform.value : this.platform,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      dbSchemaVersion: data.dbSchemaVersion.present
          ? data.dbSchemaVersion.value
          : this.dbSchemaVersion,
      syncSchemaVersion: data.syncSchemaVersion.present
          ? data.syncSchemaVersion.value
          : this.syncSchemaVersion,
      rootPath: data.rootPath.present ? data.rootPath.value : this.rootPath,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      yandexDiskConnected: data.yandexDiskConnected.present
          ? data.yandexDiskConnected.value
          : this.yandexDiskConnected,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceInfoData(')
          ..write('id: $id, ')
          ..write('deviceName: $deviceName, ')
          ..write('platform: $platform, ')
          ..write('appVersion: $appVersion, ')
          ..write('dbSchemaVersion: $dbSchemaVersion, ')
          ..write('syncSchemaVersion: $syncSchemaVersion, ')
          ..write('rootPath: $rootPath, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('yandexDiskConnected: $yandexDiskConnected, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceName,
    platform,
    appVersion,
    dbSchemaVersion,
    syncSchemaVersion,
    rootPath,
    lastSyncAt,
    yandexDiskConnected,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceInfoData &&
          other.id == this.id &&
          other.deviceName == this.deviceName &&
          other.platform == this.platform &&
          other.appVersion == this.appVersion &&
          other.dbSchemaVersion == this.dbSchemaVersion &&
          other.syncSchemaVersion == this.syncSchemaVersion &&
          other.rootPath == this.rootPath &&
          other.lastSyncAt == this.lastSyncAt &&
          other.yandexDiskConnected == this.yandexDiskConnected &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DeviceInfoCompanion extends UpdateCompanion<DeviceInfoData> {
  final Value<String> id;
  final Value<String> deviceName;
  final Value<String> platform;
  final Value<String> appVersion;
  final Value<String> dbSchemaVersion;
  final Value<String> syncSchemaVersion;
  final Value<String> rootPath;
  final Value<String?> lastSyncAt;
  final Value<bool> yandexDiskConnected;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const DeviceInfoCompanion({
    this.id = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.platform = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.dbSchemaVersion = const Value.absent(),
    this.syncSchemaVersion = const Value.absent(),
    this.rootPath = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.yandexDiskConnected = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceInfoCompanion.insert({
    required String id,
    required String deviceName,
    required String platform,
    required String appVersion,
    required String dbSchemaVersion,
    required String syncSchemaVersion,
    required String rootPath,
    this.lastSyncAt = const Value.absent(),
    this.yandexDiskConnected = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deviceName = Value(deviceName),
       platform = Value(platform),
       appVersion = Value(appVersion),
       dbSchemaVersion = Value(dbSchemaVersion),
       syncSchemaVersion = Value(syncSchemaVersion),
       rootPath = Value(rootPath),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DeviceInfoData> custom({
    Expression<String>? id,
    Expression<String>? deviceName,
    Expression<String>? platform,
    Expression<String>? appVersion,
    Expression<String>? dbSchemaVersion,
    Expression<String>? syncSchemaVersion,
    Expression<String>? rootPath,
    Expression<String>? lastSyncAt,
    Expression<bool>? yandexDiskConnected,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceName != null) 'device_name': deviceName,
      if (platform != null) 'platform': platform,
      if (appVersion != null) 'app_version': appVersion,
      if (dbSchemaVersion != null) 'db_schema_version': dbSchemaVersion,
      if (syncSchemaVersion != null) 'sync_schema_version': syncSchemaVersion,
      if (rootPath != null) 'root_path': rootPath,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (yandexDiskConnected != null)
        'yandex_disk_connected': yandexDiskConnected,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceInfoCompanion copyWith({
    Value<String>? id,
    Value<String>? deviceName,
    Value<String>? platform,
    Value<String>? appVersion,
    Value<String>? dbSchemaVersion,
    Value<String>? syncSchemaVersion,
    Value<String>? rootPath,
    Value<String?>? lastSyncAt,
    Value<bool>? yandexDiskConnected,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return DeviceInfoCompanion(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      platform: platform ?? this.platform,
      appVersion: appVersion ?? this.appVersion,
      dbSchemaVersion: dbSchemaVersion ?? this.dbSchemaVersion,
      syncSchemaVersion: syncSchemaVersion ?? this.syncSchemaVersion,
      rootPath: rootPath ?? this.rootPath,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      yandexDiskConnected: yandexDiskConnected ?? this.yandexDiskConnected,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (dbSchemaVersion.present) {
      map['db_schema_version'] = Variable<String>(dbSchemaVersion.value);
    }
    if (syncSchemaVersion.present) {
      map['sync_schema_version'] = Variable<String>(syncSchemaVersion.value);
    }
    if (rootPath.present) {
      map['root_path'] = Variable<String>(rootPath.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<String>(lastSyncAt.value);
    }
    if (yandexDiskConnected.present) {
      map['yandex_disk_connected'] = Variable<bool>(yandexDiskConnected.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceInfoCompanion(')
          ..write('id: $id, ')
          ..write('deviceName: $deviceName, ')
          ..write('platform: $platform, ')
          ..write('appVersion: $appVersion, ')
          ..write('dbSchemaVersion: $dbSchemaVersion, ')
          ..write('syncSchemaVersion: $syncSchemaVersion, ')
          ..write('rootPath: $rootPath, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('yandexDiskConnected: $yandexDiskConnected, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shortNameMeta = const VerificationMeta(
    'shortName',
  );
  @override
  late final GeneratedColumn<String> shortName = GeneratedColumn<String>(
    'short_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<String> roleId = GeneratedColumn<String>(
    'role_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastLoginAtMeta = const VerificationMeta(
    'lastLoginAt',
  );
  @override
  late final GeneratedColumn<String> lastLoginAt = GeneratedColumn<String>(
    'last_login_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    shortName,
    roleId,
    pinHash,
    isActive,
    lastLoginAt,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('short_name')) {
      context.handle(
        _shortNameMeta,
        shortName.isAcceptableOrUnknown(data['short_name']!, _shortNameMeta),
      );
    }
    if (data.containsKey('role_id')) {
      context.handle(
        _roleIdMeta,
        roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
        _lastLoginAtMeta,
        lastLoginAt.isAcceptableOrUnknown(
          data['last_login_at']!,
          _lastLoginAtMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      shortName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_name'],
      ),
      roleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_id'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      lastLoginAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_login_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String fullName;
  final String? shortName;
  final String roleId;
  final String? pinHash;
  final bool isActive;
  final String? lastLoginAt;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const User({
    required this.id,
    required this.fullName,
    this.shortName,
    required this.roleId,
    this.pinHash,
    required this.isActive,
    this.lastLoginAt,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || shortName != null) {
      map['short_name'] = Variable<String>(shortName);
    }
    map['role_id'] = Variable<String>(roleId);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<String>(lastLoginAt);
    }
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      fullName: Value(fullName),
      shortName: shortName == null && nullToAbsent
          ? const Value.absent()
          : Value(shortName),
      roleId: Value(roleId),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      isActive: Value(isActive),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      shortName: serializer.fromJson<String?>(json['shortName']),
      roleId: serializer.fromJson<String>(json['roleId']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastLoginAt: serializer.fromJson<String?>(json['lastLoginAt']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'shortName': serializer.toJson<String?>(shortName),
      'roleId': serializer.toJson<String>(roleId),
      'pinHash': serializer.toJson<String?>(pinHash),
      'isActive': serializer.toJson<bool>(isActive),
      'lastLoginAt': serializer.toJson<String?>(lastLoginAt),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  User copyWith({
    String? id,
    String? fullName,
    Value<String?> shortName = const Value.absent(),
    String? roleId,
    Value<String?> pinHash = const Value.absent(),
    bool? isActive,
    Value<String?> lastLoginAt = const Value.absent(),
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => User(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    shortName: shortName.present ? shortName.value : this.shortName,
    roleId: roleId ?? this.roleId,
    pinHash: pinHash.present ? pinHash.value : this.pinHash,
    isActive: isActive ?? this.isActive,
    lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      shortName: data.shortName.present ? data.shortName.value : this.shortName,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastLoginAt: data.lastLoginAt.present
          ? data.lastLoginAt.value
          : this.lastLoginAt,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('shortName: $shortName, ')
          ..write('roleId: $roleId, ')
          ..write('pinHash: $pinHash, ')
          ..write('isActive: $isActive, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fullName,
    shortName,
    roleId,
    pinHash,
    isActive,
    lastLoginAt,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.shortName == this.shortName &&
          other.roleId == this.roleId &&
          other.pinHash == this.pinHash &&
          other.isActive == this.isActive &&
          other.lastLoginAt == this.lastLoginAt &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String?> shortName;
  final Value<String> roleId;
  final Value<String?> pinHash;
  final Value<bool> isActive;
  final Value<String?> lastLoginAt;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.shortName = const Value.absent(),
    this.roleId = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String fullName,
    this.shortName = const Value.absent(),
    required String roleId,
    this.pinHash = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fullName = Value(fullName),
       roleId = Value(roleId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? shortName,
    Expression<String>? roleId,
    Expression<String>? pinHash,
    Expression<bool>? isActive,
    Expression<String>? lastLoginAt,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (shortName != null) 'short_name': shortName,
      if (roleId != null) 'role_id': roleId,
      if (pinHash != null) 'pin_hash': pinHash,
      if (isActive != null) 'is_active': isActive,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String?>? shortName,
    Value<String>? roleId,
    Value<String?>? pinHash,
    Value<bool>? isActive,
    Value<String?>? lastLoginAt,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      shortName: shortName ?? this.shortName,
      roleId: roleId ?? this.roleId,
      pinHash: pinHash ?? this.pinHash,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (shortName.present) {
      map['short_name'] = Variable<String>(shortName.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<String>(roleId.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<String>(lastLoginAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('shortName: $shortName, ')
          ..write('roleId: $roleId, ')
          ..write('pinHash: $pinHash, ')
          ..write('isActive: $isActive, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepartmentsTable extends Departments
    with TableInfo<$DepartmentsTable, Department> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    code,
    sortOrder,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'departments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Department> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Department map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Department(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $DepartmentsTable createAlias(String alias) {
    return $DepartmentsTable(attachedDatabase, alias);
  }
}

class Department extends DataClass implements Insertable<Department> {
  final String id;
  final String name;
  final String? code;
  final int sortOrder;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const Department({
    required this.id,
    required this.name,
    this.code,
    required this.sortOrder,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  DepartmentsCompanion toCompanion(bool nullToAbsent) {
    return DepartmentsCompanion(
      id: Value(id),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      sortOrder: Value(sortOrder),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Department.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Department(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Department copyWith({
    String? id,
    String? name,
    Value<String?> code = const Value.absent(),
    int? sortOrder,
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => Department(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    sortOrder: sortOrder ?? this.sortOrder,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Department copyWithCompanion(DepartmentsCompanion data) {
    return Department(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Department(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    code,
    sortOrder,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Department &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.sortOrder == this.sortOrder &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class DepartmentsCompanion extends UpdateCompanion<Department> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> code;
  final Value<int> sortOrder;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const DepartmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepartmentsCompanion.insert({
    required String id,
    required String name,
    this.code = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Department> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? sortOrder,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepartmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? code,
    Value<int>? sortOrder,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return DepartmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      sortOrder: sortOrder ?? this.sortOrder,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkshopsTable extends Workshops
    with TableInfo<$WorkshopsTable, Workshop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkshopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    departmentId,
    name,
    code,
    sortOrder,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workshops';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workshop> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workshop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workshop(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $WorkshopsTable createAlias(String alias) {
    return $WorkshopsTable(attachedDatabase, alias);
  }
}

class Workshop extends DataClass implements Insertable<Workshop> {
  final String id;
  final String departmentId;
  final String name;
  final String? code;
  final int sortOrder;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const Workshop({
    required this.id,
    required this.departmentId,
    required this.name,
    this.code,
    required this.sortOrder,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['department_id'] = Variable<String>(departmentId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  WorkshopsCompanion toCompanion(bool nullToAbsent) {
    return WorkshopsCompanion(
      id: Value(id),
      departmentId: Value(departmentId),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      sortOrder: Value(sortOrder),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Workshop.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workshop(
      id: serializer.fromJson<String>(json['id']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'departmentId': serializer.toJson<String>(departmentId),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Workshop copyWith({
    String? id,
    String? departmentId,
    String? name,
    Value<String?> code = const Value.absent(),
    int? sortOrder,
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => Workshop(
    id: id ?? this.id,
    departmentId: departmentId ?? this.departmentId,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    sortOrder: sortOrder ?? this.sortOrder,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Workshop copyWithCompanion(WorkshopsCompanion data) {
    return Workshop(
      id: data.id.present ? data.id.value : this.id,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workshop(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    departmentId,
    name,
    code,
    sortOrder,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workshop &&
          other.id == this.id &&
          other.departmentId == this.departmentId &&
          other.name == this.name &&
          other.code == this.code &&
          other.sortOrder == this.sortOrder &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class WorkshopsCompanion extends UpdateCompanion<Workshop> {
  final Value<String> id;
  final Value<String> departmentId;
  final Value<String> name;
  final Value<String?> code;
  final Value<int> sortOrder;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const WorkshopsCompanion({
    this.id = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkshopsCompanion.insert({
    required String id,
    required String departmentId,
    required String name,
    this.code = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       departmentId = Value(departmentId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Workshop> custom({
    Expression<String>? id,
    Expression<String>? departmentId,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? sortOrder,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (departmentId != null) 'department_id': departmentId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkshopsCompanion copyWith({
    Value<String>? id,
    Value<String>? departmentId,
    Value<String>? name,
    Value<String?>? code,
    Value<int>? sortOrder,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return WorkshopsCompanion(
      id: id ?? this.id,
      departmentId: departmentId ?? this.departmentId,
      name: name ?? this.name,
      code: code ?? this.code,
      sortOrder: sortOrder ?? this.sortOrder,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkshopsCompanion(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SectionsTable extends Sections with TableInfo<$SectionsTable, Section> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workshopIdMeta = const VerificationMeta(
    'workshopId',
  );
  @override
  late final GeneratedColumn<String> workshopId = GeneratedColumn<String>(
    'workshop_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workshopId,
    name,
    code,
    sortOrder,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Section> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workshop_id')) {
      context.handle(
        _workshopIdMeta,
        workshopId.isAcceptableOrUnknown(data['workshop_id']!, _workshopIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workshopIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Section map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Section(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workshopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workshop_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $SectionsTable createAlias(String alias) {
    return $SectionsTable(attachedDatabase, alias);
  }
}

class Section extends DataClass implements Insertable<Section> {
  final String id;
  final String workshopId;
  final String name;
  final String? code;
  final int sortOrder;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const Section({
    required this.id,
    required this.workshopId,
    required this.name,
    this.code,
    required this.sortOrder,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workshop_id'] = Variable<String>(workshopId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  SectionsCompanion toCompanion(bool nullToAbsent) {
    return SectionsCompanion(
      id: Value(id),
      workshopId: Value(workshopId),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      sortOrder: Value(sortOrder),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Section.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Section(
      id: serializer.fromJson<String>(json['id']),
      workshopId: serializer.fromJson<String>(json['workshopId']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workshopId': serializer.toJson<String>(workshopId),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Section copyWith({
    String? id,
    String? workshopId,
    String? name,
    Value<String?> code = const Value.absent(),
    int? sortOrder,
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => Section(
    id: id ?? this.id,
    workshopId: workshopId ?? this.workshopId,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    sortOrder: sortOrder ?? this.sortOrder,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Section copyWithCompanion(SectionsCompanion data) {
    return Section(
      id: data.id.present ? data.id.value : this.id,
      workshopId: data.workshopId.present
          ? data.workshopId.value
          : this.workshopId,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Section(')
          ..write('id: $id, ')
          ..write('workshopId: $workshopId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workshopId,
    name,
    code,
    sortOrder,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Section &&
          other.id == this.id &&
          other.workshopId == this.workshopId &&
          other.name == this.name &&
          other.code == this.code &&
          other.sortOrder == this.sortOrder &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class SectionsCompanion extends UpdateCompanion<Section> {
  final Value<String> id;
  final Value<String> workshopId;
  final Value<String> name;
  final Value<String?> code;
  final Value<int> sortOrder;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const SectionsCompanion({
    this.id = const Value.absent(),
    this.workshopId = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SectionsCompanion.insert({
    required String id,
    required String workshopId,
    required String name,
    this.code = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workshopId = Value(workshopId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Section> custom({
    Expression<String>? id,
    Expression<String>? workshopId,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? sortOrder,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workshopId != null) 'workshop_id': workshopId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? workshopId,
    Value<String>? name,
    Value<String?>? code,
    Value<int>? sortOrder,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return SectionsCompanion(
      id: id ?? this.id,
      workshopId: workshopId ?? this.workshopId,
      name: name ?? this.name,
      code: code ?? this.code,
      sortOrder: sortOrder ?? this.sortOrder,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workshopId.present) {
      map['workshop_id'] = Variable<String>(workshopId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionsCompanion(')
          ..write('id: $id, ')
          ..write('workshopId: $workshopId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogObjectsTable extends CatalogObjects
    with TableInfo<$CatalogObjectsTable, CatalogObject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogObjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    sectionId,
    parentId,
    name,
    code,
    description,
    sortOrder,
    isActive,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'objects';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogObject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogObject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogObject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $CatalogObjectsTable createAlias(String alias) {
    return $CatalogObjectsTable(attachedDatabase, alias);
  }
}

class CatalogObject extends DataClass implements Insertable<CatalogObject> {
  final String id;
  final String type;
  final String? sectionId;
  final String? parentId;
  final String name;
  final String? code;
  final String? description;
  final int sortOrder;
  final bool isActive;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const CatalogObject({
    required this.id,
    required this.type,
    this.sectionId,
    this.parentId,
    required this.name,
    this.code,
    this.description,
    required this.sortOrder,
    required this.isActive,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || sectionId != null) {
      map['section_id'] = Variable<String>(sectionId);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  CatalogObjectsCompanion toCompanion(bool nullToAbsent) {
    return CatalogObjectsCompanion(
      id: Value(id),
      type: Value(type),
      sectionId: sectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sectionId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory CatalogObject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogObject(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      sectionId: serializer.fromJson<String?>(json['sectionId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      description: serializer.fromJson<String?>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'sectionId': serializer.toJson<String?>(sectionId),
      'parentId': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'description': serializer.toJson<String?>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  CatalogObject copyWith({
    String? id,
    String? type,
    Value<String?> sectionId = const Value.absent(),
    Value<String?> parentId = const Value.absent(),
    String? name,
    Value<String?> code = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? sortOrder,
    bool? isActive,
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => CatalogObject(
    id: id ?? this.id,
    type: type ?? this.type,
    sectionId: sectionId.present ? sectionId.value : this.sectionId,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    description: description.present ? description.value : this.description,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  CatalogObject copyWithCompanion(CatalogObjectsCompanion data) {
    return CatalogObject(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogObject(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('sectionId: $sectionId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    sectionId,
    parentId,
    name,
    code,
    description,
    sortOrder,
    isActive,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogObject &&
          other.id == this.id &&
          other.type == this.type &&
          other.sectionId == this.sectionId &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.code == this.code &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class CatalogObjectsCompanion extends UpdateCompanion<CatalogObject> {
  final Value<String> id;
  final Value<String> type;
  final Value<String?> sectionId;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<String?> code;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const CatalogObjectsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogObjectsCompanion.insert({
    required String id,
    required String type,
    this.sectionId = const Value.absent(),
    this.parentId = const Value.absent(),
    required String name,
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CatalogObject> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? sectionId,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (sectionId != null) 'section_id': sectionId,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogObjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String?>? sectionId,
    Value<String?>? parentId,
    Value<String>? name,
    Value<String?>? code,
    Value<String?>? description,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return CatalogObjectsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      sectionId: sectionId ?? this.sectionId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogObjectsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('sectionId: $sectionId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ObjectRelationsTable extends ObjectRelations
    with TableInfo<$ObjectRelationsTable, ObjectRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObjectRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentObjectIdMeta = const VerificationMeta(
    'parentObjectId',
  );
  @override
  late final GeneratedColumn<String> parentObjectId = GeneratedColumn<String>(
    'parent_object_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childObjectIdMeta = const VerificationMeta(
    'childObjectId',
  );
  @override
  late final GeneratedColumn<String> childObjectId = GeneratedColumn<String>(
    'child_object_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationTypeMeta = const VerificationMeta(
    'relationType',
  );
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
    'relation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('contains'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentObjectId,
    childObjectId,
    relationType,
    sortOrder,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'object_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ObjectRelation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('parent_object_id')) {
      context.handle(
        _parentObjectIdMeta,
        parentObjectId.isAcceptableOrUnknown(
          data['parent_object_id']!,
          _parentObjectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parentObjectIdMeta);
    }
    if (data.containsKey('child_object_id')) {
      context.handle(
        _childObjectIdMeta,
        childObjectId.isAcceptableOrUnknown(
          data['child_object_id']!,
          _childObjectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_childObjectIdMeta);
    }
    if (data.containsKey('relation_type')) {
      context.handle(
        _relationTypeMeta,
        relationType.isAcceptableOrUnknown(
          data['relation_type']!,
          _relationTypeMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {parentObjectId, childObjectId},
  ];
  @override
  ObjectRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ObjectRelation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parentObjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_object_id'],
      )!,
      childObjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_object_id'],
      )!,
      relationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation_type'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ObjectRelationsTable createAlias(String alias) {
    return $ObjectRelationsTable(attachedDatabase, alias);
  }
}

class ObjectRelation extends DataClass implements Insertable<ObjectRelation> {
  final String id;
  final String parentObjectId;
  final String childObjectId;
  final String relationType;
  final int sortOrder;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const ObjectRelation({
    required this.id,
    required this.parentObjectId,
    required this.childObjectId,
    required this.relationType,
    required this.sortOrder,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['parent_object_id'] = Variable<String>(parentObjectId);
    map['child_object_id'] = Variable<String>(childObjectId);
    map['relation_type'] = Variable<String>(relationType);
    map['sort_order'] = Variable<int>(sortOrder);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ObjectRelationsCompanion toCompanion(bool nullToAbsent) {
    return ObjectRelationsCompanion(
      id: Value(id),
      parentObjectId: Value(parentObjectId),
      childObjectId: Value(childObjectId),
      relationType: Value(relationType),
      sortOrder: Value(sortOrder),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory ObjectRelation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ObjectRelation(
      id: serializer.fromJson<String>(json['id']),
      parentObjectId: serializer.fromJson<String>(json['parentObjectId']),
      childObjectId: serializer.fromJson<String>(json['childObjectId']),
      relationType: serializer.fromJson<String>(json['relationType']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentObjectId': serializer.toJson<String>(parentObjectId),
      'childObjectId': serializer.toJson<String>(childObjectId),
      'relationType': serializer.toJson<String>(relationType),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ObjectRelation copyWith({
    String? id,
    String? parentObjectId,
    String? childObjectId,
    String? relationType,
    int? sortOrder,
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => ObjectRelation(
    id: id ?? this.id,
    parentObjectId: parentObjectId ?? this.parentObjectId,
    childObjectId: childObjectId ?? this.childObjectId,
    relationType: relationType ?? this.relationType,
    sortOrder: sortOrder ?? this.sortOrder,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  ObjectRelation copyWithCompanion(ObjectRelationsCompanion data) {
    return ObjectRelation(
      id: data.id.present ? data.id.value : this.id,
      parentObjectId: data.parentObjectId.present
          ? data.parentObjectId.value
          : this.parentObjectId,
      childObjectId: data.childObjectId.present
          ? data.childObjectId.value
          : this.childObjectId,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ObjectRelation(')
          ..write('id: $id, ')
          ..write('parentObjectId: $parentObjectId, ')
          ..write('childObjectId: $childObjectId, ')
          ..write('relationType: $relationType, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parentObjectId,
    childObjectId,
    relationType,
    sortOrder,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ObjectRelation &&
          other.id == this.id &&
          other.parentObjectId == this.parentObjectId &&
          other.childObjectId == this.childObjectId &&
          other.relationType == this.relationType &&
          other.sortOrder == this.sortOrder &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class ObjectRelationsCompanion extends UpdateCompanion<ObjectRelation> {
  final Value<String> id;
  final Value<String> parentObjectId;
  final Value<String> childObjectId;
  final Value<String> relationType;
  final Value<int> sortOrder;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ObjectRelationsCompanion({
    this.id = const Value.absent(),
    this.parentObjectId = const Value.absent(),
    this.childObjectId = const Value.absent(),
    this.relationType = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ObjectRelationsCompanion.insert({
    required String id,
    required String parentObjectId,
    required String childObjectId,
    this.relationType = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       parentObjectId = Value(parentObjectId),
       childObjectId = Value(childObjectId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ObjectRelation> custom({
    Expression<String>? id,
    Expression<String>? parentObjectId,
    Expression<String>? childObjectId,
    Expression<String>? relationType,
    Expression<int>? sortOrder,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentObjectId != null) 'parent_object_id': parentObjectId,
      if (childObjectId != null) 'child_object_id': childObjectId,
      if (relationType != null) 'relation_type': relationType,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ObjectRelationsCompanion copyWith({
    Value<String>? id,
    Value<String>? parentObjectId,
    Value<String>? childObjectId,
    Value<String>? relationType,
    Value<int>? sortOrder,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return ObjectRelationsCompanion(
      id: id ?? this.id,
      parentObjectId: parentObjectId ?? this.parentObjectId,
      childObjectId: childObjectId ?? this.childObjectId,
      relationType: relationType ?? this.relationType,
      sortOrder: sortOrder ?? this.sortOrder,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (parentObjectId.present) {
      map['parent_object_id'] = Variable<String>(parentObjectId.value);
    }
    if (childObjectId.present) {
      map['child_object_id'] = Variable<String>(childObjectId.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObjectRelationsCompanion(')
          ..write('id: $id, ')
          ..write('parentObjectId: $parentObjectId, ')
          ..write('childObjectId: $childObjectId, ')
          ..write('relationType: $relationType, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ComponentsTable extends Components
    with TableInfo<$ComponentsTable, Component> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComponentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objectIdMeta = const VerificationMeta(
    'objectId',
  );
  @override
  late final GeneratedColumn<String> objectId = GeneratedColumn<String>(
    'object_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    objectId,
    name,
    code,
    description,
    sortOrder,
    isRequired,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'components';
  @override
  VerificationContext validateIntegrity(
    Insertable<Component> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('object_id')) {
      context.handle(
        _objectIdMeta,
        objectId.isAcceptableOrUnknown(data['object_id']!, _objectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_objectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Component map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Component(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      objectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}object_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ComponentsTable createAlias(String alias) {
    return $ComponentsTable(attachedDatabase, alias);
  }
}

class Component extends DataClass implements Insertable<Component> {
  final String id;
  final String objectId;
  final String name;
  final String? code;
  final String? description;
  final int sortOrder;
  final bool isRequired;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const Component({
    required this.id,
    required this.objectId,
    required this.name,
    this.code,
    this.description,
    required this.sortOrder,
    required this.isRequired,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['object_id'] = Variable<String>(objectId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_required'] = Variable<bool>(isRequired);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ComponentsCompanion toCompanion(bool nullToAbsent) {
    return ComponentsCompanion(
      id: Value(id),
      objectId: Value(objectId),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sortOrder: Value(sortOrder),
      isRequired: Value(isRequired),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Component.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Component(
      id: serializer.fromJson<String>(json['id']),
      objectId: serializer.fromJson<String>(json['objectId']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      description: serializer.fromJson<String?>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'objectId': serializer.toJson<String>(objectId),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'description': serializer.toJson<String?>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isRequired': serializer.toJson<bool>(isRequired),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Component copyWith({
    String? id,
    String? objectId,
    String? name,
    Value<String?> code = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? sortOrder,
    bool? isRequired,
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => Component(
    id: id ?? this.id,
    objectId: objectId ?? this.objectId,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    description: description.present ? description.value : this.description,
    sortOrder: sortOrder ?? this.sortOrder,
    isRequired: isRequired ?? this.isRequired,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Component copyWithCompanion(ComponentsCompanion data) {
    return Component(
      id: data.id.present ? data.id.value : this.id,
      objectId: data.objectId.present ? data.objectId.value : this.objectId,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Component(')
          ..write('id: $id, ')
          ..write('objectId: $objectId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isRequired: $isRequired, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    objectId,
    name,
    code,
    description,
    sortOrder,
    isRequired,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Component &&
          other.id == this.id &&
          other.objectId == this.objectId &&
          other.name == this.name &&
          other.code == this.code &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.isRequired == this.isRequired &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class ComponentsCompanion extends UpdateCompanion<Component> {
  final Value<String> id;
  final Value<String> objectId;
  final Value<String> name;
  final Value<String?> code;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<bool> isRequired;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ComponentsCompanion({
    this.id = const Value.absent(),
    this.objectId = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComponentsCompanion.insert({
    required String id,
    required String objectId,
    required String name,
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       objectId = Value(objectId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Component> custom({
    Expression<String>? id,
    Expression<String>? objectId,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<bool>? isRequired,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (objectId != null) 'object_id': objectId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isRequired != null) 'is_required': isRequired,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComponentsCompanion copyWith({
    Value<String>? id,
    Value<String>? objectId,
    Value<String>? name,
    Value<String?>? code,
    Value<String?>? description,
    Value<int>? sortOrder,
    Value<bool>? isRequired,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return ComponentsCompanion(
      id: id ?? this.id,
      objectId: objectId ?? this.objectId,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isRequired: isRequired ?? this.isRequired,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (objectId.present) {
      map['object_id'] = Variable<String>(objectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComponentsCompanion(')
          ..write('id: $id, ')
          ..write('objectId: $objectId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isRequired: $isRequired, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistsTable extends Checklists
    with TableInfo<$ChecklistsTable, Checklist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    isActive,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Checklist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Checklist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Checklist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ChecklistsTable createAlias(String alias) {
    return $ChecklistsTable(attachedDatabase, alias);
  }
}

class Checklist extends DataClass implements Insertable<Checklist> {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const Checklist({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ChecklistsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Checklist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Checklist(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Checklist copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? isActive,
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => Checklist(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Checklist copyWithCompanion(ChecklistsCompanion data) {
    return Checklist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Checklist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    isActive,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Checklist &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class ChecklistsCompanion extends UpdateCompanion<Checklist> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ChecklistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Checklist> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return ChecklistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTable extends ChecklistItems
    with TableInfo<$ChecklistItemsTable, ChecklistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checklistIdMeta = const VerificationMeta(
    'checklistId',
  );
  @override
  late final GeneratedColumn<String> checklistId = GeneratedColumn<String>(
    'checklist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expectedResultMeta = const VerificationMeta(
    'expectedResult',
  );
  @override
  late final GeneratedColumn<String> expectedResult = GeneratedColumn<String>(
    'expected_result',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultTypeMeta = const VerificationMeta(
    'resultType',
  );
  @override
  late final GeneratedColumn<String> resultType = GeneratedColumn<String>(
    'result_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pass_fail_na'),
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    checklistId,
    componentId,
    title,
    description,
    expectedResult,
    resultType,
    isRequired,
    sortOrder,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('checklist_id')) {
      context.handle(
        _checklistIdMeta,
        checklistId.isAcceptableOrUnknown(
          data['checklist_id']!,
          _checklistIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checklistIdMeta);
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('expected_result')) {
      context.handle(
        _expectedResultMeta,
        expectedResult.isAcceptableOrUnknown(
          data['expected_result']!,
          _expectedResultMeta,
        ),
      );
    }
    if (data.containsKey('result_type')) {
      context.handle(
        _resultTypeMeta,
        resultType.isAcceptableOrUnknown(data['result_type']!, _resultTypeMeta),
      );
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      checklistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checklist_id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      expectedResult: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expected_result'],
      ),
      resultType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_type'],
      )!,
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ChecklistItemsTable createAlias(String alias) {
    return $ChecklistItemsTable(attachedDatabase, alias);
  }
}

class ChecklistItem extends DataClass implements Insertable<ChecklistItem> {
  final String id;
  final String checklistId;
  final String? componentId;
  final String title;
  final String? description;
  final String? expectedResult;
  final String resultType;
  final bool isRequired;
  final int sortOrder;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const ChecklistItem({
    required this.id,
    required this.checklistId,
    this.componentId,
    required this.title,
    this.description,
    this.expectedResult,
    required this.resultType,
    required this.isRequired,
    required this.sortOrder,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['checklist_id'] = Variable<String>(checklistId);
    if (!nullToAbsent || componentId != null) {
      map['component_id'] = Variable<String>(componentId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || expectedResult != null) {
      map['expected_result'] = Variable<String>(expectedResult);
    }
    map['result_type'] = Variable<String>(resultType);
    map['is_required'] = Variable<bool>(isRequired);
    map['sort_order'] = Variable<int>(sortOrder);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsCompanion(
      id: Value(id),
      checklistId: Value(checklistId),
      componentId: componentId == null && nullToAbsent
          ? const Value.absent()
          : Value(componentId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      expectedResult: expectedResult == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedResult),
      resultType: Value(resultType),
      isRequired: Value(isRequired),
      sortOrder: Value(sortOrder),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory ChecklistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItem(
      id: serializer.fromJson<String>(json['id']),
      checklistId: serializer.fromJson<String>(json['checklistId']),
      componentId: serializer.fromJson<String?>(json['componentId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      expectedResult: serializer.fromJson<String?>(json['expectedResult']),
      resultType: serializer.fromJson<String>(json['resultType']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checklistId': serializer.toJson<String>(checklistId),
      'componentId': serializer.toJson<String?>(componentId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'expectedResult': serializer.toJson<String?>(expectedResult),
      'resultType': serializer.toJson<String>(resultType),
      'isRequired': serializer.toJson<bool>(isRequired),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ChecklistItem copyWith({
    String? id,
    String? checklistId,
    Value<String?> componentId = const Value.absent(),
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> expectedResult = const Value.absent(),
    String? resultType,
    bool? isRequired,
    int? sortOrder,
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => ChecklistItem(
    id: id ?? this.id,
    checklistId: checklistId ?? this.checklistId,
    componentId: componentId.present ? componentId.value : this.componentId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    expectedResult: expectedResult.present
        ? expectedResult.value
        : this.expectedResult,
    resultType: resultType ?? this.resultType,
    isRequired: isRequired ?? this.isRequired,
    sortOrder: sortOrder ?? this.sortOrder,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  ChecklistItem copyWithCompanion(ChecklistItemsCompanion data) {
    return ChecklistItem(
      id: data.id.present ? data.id.value : this.id,
      checklistId: data.checklistId.present
          ? data.checklistId.value
          : this.checklistId,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      expectedResult: data.expectedResult.present
          ? data.expectedResult.value
          : this.expectedResult,
      resultType: data.resultType.present
          ? data.resultType.value
          : this.resultType,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItem(')
          ..write('id: $id, ')
          ..write('checklistId: $checklistId, ')
          ..write('componentId: $componentId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('expectedResult: $expectedResult, ')
          ..write('resultType: $resultType, ')
          ..write('isRequired: $isRequired, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    checklistId,
    componentId,
    title,
    description,
    expectedResult,
    resultType,
    isRequired,
    sortOrder,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItem &&
          other.id == this.id &&
          other.checklistId == this.checklistId &&
          other.componentId == this.componentId &&
          other.title == this.title &&
          other.description == this.description &&
          other.expectedResult == this.expectedResult &&
          other.resultType == this.resultType &&
          other.isRequired == this.isRequired &&
          other.sortOrder == this.sortOrder &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class ChecklistItemsCompanion extends UpdateCompanion<ChecklistItem> {
  final Value<String> id;
  final Value<String> checklistId;
  final Value<String?> componentId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> expectedResult;
  final Value<String> resultType;
  final Value<bool> isRequired;
  final Value<int> sortOrder;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.checklistId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.expectedResult = const Value.absent(),
    this.resultType = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistItemsCompanion.insert({
    required String id,
    required String checklistId,
    this.componentId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.expectedResult = const Value.absent(),
    this.resultType = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       checklistId = Value(checklistId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChecklistItem> custom({
    Expression<String>? id,
    Expression<String>? checklistId,
    Expression<String>? componentId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? expectedResult,
    Expression<String>? resultType,
    Expression<bool>? isRequired,
    Expression<int>? sortOrder,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checklistId != null) 'checklist_id': checklistId,
      if (componentId != null) 'component_id': componentId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (expectedResult != null) 'expected_result': expectedResult,
      if (resultType != null) 'result_type': resultType,
      if (isRequired != null) 'is_required': isRequired,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? checklistId,
    Value<String?>? componentId,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? expectedResult,
    Value<String>? resultType,
    Value<bool>? isRequired,
    Value<int>? sortOrder,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return ChecklistItemsCompanion(
      id: id ?? this.id,
      checklistId: checklistId ?? this.checklistId,
      componentId: componentId ?? this.componentId,
      title: title ?? this.title,
      description: description ?? this.description,
      expectedResult: expectedResult ?? this.expectedResult,
      resultType: resultType ?? this.resultType,
      isRequired: isRequired ?? this.isRequired,
      sortOrder: sortOrder ?? this.sortOrder,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checklistId.present) {
      map['checklist_id'] = Variable<String>(checklistId.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (expectedResult.present) {
      map['expected_result'] = Variable<String>(expectedResult.value);
    }
    if (resultType.present) {
      map['result_type'] = Variable<String>(resultType.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('checklistId: $checklistId, ')
          ..write('componentId: $componentId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('expectedResult: $expectedResult, ')
          ..write('resultType: $resultType, ')
          ..write('isRequired: $isRequired, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistBindingsTable extends ChecklistBindings
    with TableInfo<$ChecklistBindingsTable, ChecklistBinding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistBindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checklistIdMeta = const VerificationMeta(
    'checklistId',
  );
  @override
  late final GeneratedColumn<String> checklistId = GeneratedColumn<String>(
    'checklist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetObjectTypeMeta = const VerificationMeta(
    'targetObjectType',
  );
  @override
  late final GeneratedColumn<String> targetObjectType = GeneratedColumn<String>(
    'target_object_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    checklistId,
    targetType,
    targetId,
    targetObjectType,
    priority,
    isRequired,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_bindings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistBinding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('checklist_id')) {
      context.handle(
        _checklistIdMeta,
        checklistId.isAcceptableOrUnknown(
          data['checklist_id']!,
          _checklistIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checklistIdMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTypeMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    }
    if (data.containsKey('target_object_type')) {
      context.handle(
        _targetObjectTypeMeta,
        targetObjectType.isAcceptableOrUnknown(
          data['target_object_type']!,
          _targetObjectTypeMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistBinding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistBinding(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      checklistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checklist_id'],
      )!,
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_type'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      ),
      targetObjectType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_object_type'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ChecklistBindingsTable createAlias(String alias) {
    return $ChecklistBindingsTable(attachedDatabase, alias);
  }
}

class ChecklistBinding extends DataClass
    implements Insertable<ChecklistBinding> {
  final String id;
  final String checklistId;
  final String targetType;
  final String? targetId;
  final String? targetObjectType;
  final int priority;
  final bool isRequired;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const ChecklistBinding({
    required this.id,
    required this.checklistId,
    required this.targetType,
    this.targetId,
    this.targetObjectType,
    required this.priority,
    required this.isRequired,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['checklist_id'] = Variable<String>(checklistId);
    map['target_type'] = Variable<String>(targetType);
    if (!nullToAbsent || targetId != null) {
      map['target_id'] = Variable<String>(targetId);
    }
    if (!nullToAbsent || targetObjectType != null) {
      map['target_object_type'] = Variable<String>(targetObjectType);
    }
    map['priority'] = Variable<int>(priority);
    map['is_required'] = Variable<bool>(isRequired);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ChecklistBindingsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistBindingsCompanion(
      id: Value(id),
      checklistId: Value(checklistId),
      targetType: Value(targetType),
      targetId: targetId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetId),
      targetObjectType: targetObjectType == null && nullToAbsent
          ? const Value.absent()
          : Value(targetObjectType),
      priority: Value(priority),
      isRequired: Value(isRequired),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory ChecklistBinding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistBinding(
      id: serializer.fromJson<String>(json['id']),
      checklistId: serializer.fromJson<String>(json['checklistId']),
      targetType: serializer.fromJson<String>(json['targetType']),
      targetId: serializer.fromJson<String?>(json['targetId']),
      targetObjectType: serializer.fromJson<String?>(json['targetObjectType']),
      priority: serializer.fromJson<int>(json['priority']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checklistId': serializer.toJson<String>(checklistId),
      'targetType': serializer.toJson<String>(targetType),
      'targetId': serializer.toJson<String?>(targetId),
      'targetObjectType': serializer.toJson<String?>(targetObjectType),
      'priority': serializer.toJson<int>(priority),
      'isRequired': serializer.toJson<bool>(isRequired),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ChecklistBinding copyWith({
    String? id,
    String? checklistId,
    String? targetType,
    Value<String?> targetId = const Value.absent(),
    Value<String?> targetObjectType = const Value.absent(),
    int? priority,
    bool? isRequired,
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => ChecklistBinding(
    id: id ?? this.id,
    checklistId: checklistId ?? this.checklistId,
    targetType: targetType ?? this.targetType,
    targetId: targetId.present ? targetId.value : this.targetId,
    targetObjectType: targetObjectType.present
        ? targetObjectType.value
        : this.targetObjectType,
    priority: priority ?? this.priority,
    isRequired: isRequired ?? this.isRequired,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  ChecklistBinding copyWithCompanion(ChecklistBindingsCompanion data) {
    return ChecklistBinding(
      id: data.id.present ? data.id.value : this.id,
      checklistId: data.checklistId.present
          ? data.checklistId.value
          : this.checklistId,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      targetObjectType: data.targetObjectType.present
          ? data.targetObjectType.value
          : this.targetObjectType,
      priority: data.priority.present ? data.priority.value : this.priority,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistBinding(')
          ..write('id: $id, ')
          ..write('checklistId: $checklistId, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('targetObjectType: $targetObjectType, ')
          ..write('priority: $priority, ')
          ..write('isRequired: $isRequired, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    checklistId,
    targetType,
    targetId,
    targetObjectType,
    priority,
    isRequired,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistBinding &&
          other.id == this.id &&
          other.checklistId == this.checklistId &&
          other.targetType == this.targetType &&
          other.targetId == this.targetId &&
          other.targetObjectType == this.targetObjectType &&
          other.priority == this.priority &&
          other.isRequired == this.isRequired &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class ChecklistBindingsCompanion extends UpdateCompanion<ChecklistBinding> {
  final Value<String> id;
  final Value<String> checklistId;
  final Value<String> targetType;
  final Value<String?> targetId;
  final Value<String?> targetObjectType;
  final Value<int> priority;
  final Value<bool> isRequired;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ChecklistBindingsCompanion({
    this.id = const Value.absent(),
    this.checklistId = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetId = const Value.absent(),
    this.targetObjectType = const Value.absent(),
    this.priority = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistBindingsCompanion.insert({
    required String id,
    required String checklistId,
    required String targetType,
    this.targetId = const Value.absent(),
    this.targetObjectType = const Value.absent(),
    this.priority = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       checklistId = Value(checklistId),
       targetType = Value(targetType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChecklistBinding> custom({
    Expression<String>? id,
    Expression<String>? checklistId,
    Expression<String>? targetType,
    Expression<String>? targetId,
    Expression<String>? targetObjectType,
    Expression<int>? priority,
    Expression<bool>? isRequired,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checklistId != null) 'checklist_id': checklistId,
      if (targetType != null) 'target_type': targetType,
      if (targetId != null) 'target_id': targetId,
      if (targetObjectType != null) 'target_object_type': targetObjectType,
      if (priority != null) 'priority': priority,
      if (isRequired != null) 'is_required': isRequired,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistBindingsCompanion copyWith({
    Value<String>? id,
    Value<String>? checklistId,
    Value<String>? targetType,
    Value<String?>? targetId,
    Value<String?>? targetObjectType,
    Value<int>? priority,
    Value<bool>? isRequired,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return ChecklistBindingsCompanion(
      id: id ?? this.id,
      checklistId: checklistId ?? this.checklistId,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      targetObjectType: targetObjectType ?? this.targetObjectType,
      priority: priority ?? this.priority,
      isRequired: isRequired ?? this.isRequired,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checklistId.present) {
      map['checklist_id'] = Variable<String>(checklistId.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (targetObjectType.present) {
      map['target_object_type'] = Variable<String>(targetObjectType.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistBindingsCompanion(')
          ..write('id: $id, ')
          ..write('checklistId: $checklistId, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('targetObjectType: $targetObjectType, ')
          ..write('priority: $priority, ')
          ..write('isRequired: $isRequired, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReferencePackageIdMeta =
      const VerificationMeta('lastReferencePackageId');
  @override
  late final GeneratedColumn<String> lastReferencePackageId =
      GeneratedColumn<String>(
        'last_reference_package_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastReferenceSyncAtMeta =
      const VerificationMeta('lastReferenceSyncAt');
  @override
  late final GeneratedColumn<String> lastReferenceSyncAt =
      GeneratedColumn<String>(
        'last_reference_sync_at',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastResultPushAtMeta = const VerificationMeta(
    'lastResultPushAt',
  );
  @override
  late final GeneratedColumn<String> lastResultPushAt = GeneratedColumn<String>(
    'last_result_push_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastResultPullAtMeta = const VerificationMeta(
    'lastResultPullAt',
  );
  @override
  late final GeneratedColumn<String> lastResultPullAt = GeneratedColumn<String>(
    'last_result_pull_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSuccessAtMeta = const VerificationMeta(
    'lastSuccessAt',
  );
  @override
  late final GeneratedColumn<String> lastSuccessAt = GeneratedColumn<String>(
    'last_success_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<String> schemaVersion = GeneratedColumn<String>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    lastReferencePackageId,
    lastReferenceSyncAt,
    lastResultPushAt,
    lastResultPullAt,
    lastSuccessAt,
    lastError,
    schemaVersion,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('last_reference_package_id')) {
      context.handle(
        _lastReferencePackageIdMeta,
        lastReferencePackageId.isAcceptableOrUnknown(
          data['last_reference_package_id']!,
          _lastReferencePackageIdMeta,
        ),
      );
    }
    if (data.containsKey('last_reference_sync_at')) {
      context.handle(
        _lastReferenceSyncAtMeta,
        lastReferenceSyncAt.isAcceptableOrUnknown(
          data['last_reference_sync_at']!,
          _lastReferenceSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('last_result_push_at')) {
      context.handle(
        _lastResultPushAtMeta,
        lastResultPushAt.isAcceptableOrUnknown(
          data['last_result_push_at']!,
          _lastResultPushAtMeta,
        ),
      );
    }
    if (data.containsKey('last_result_pull_at')) {
      context.handle(
        _lastResultPullAtMeta,
        lastResultPullAt.isAcceptableOrUnknown(
          data['last_result_pull_at']!,
          _lastResultPullAtMeta,
        ),
      );
    }
    if (data.containsKey('last_success_at')) {
      context.handle(
        _lastSuccessAtMeta,
        lastSuccessAt.isAcceptableOrUnknown(
          data['last_success_at']!,
          _lastSuccessAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      lastReferencePackageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_reference_package_id'],
      ),
      lastReferenceSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_reference_sync_at'],
      ),
      lastResultPushAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_result_push_at'],
      ),
      lastResultPullAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_result_pull_at'],
      ),
      lastSuccessAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_success_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schema_version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final String id;
  final String deviceId;
  final String? lastReferencePackageId;
  final String? lastReferenceSyncAt;
  final String? lastResultPushAt;
  final String? lastResultPullAt;
  final String? lastSuccessAt;
  final String? lastError;
  final String schemaVersion;
  final String updatedAt;
  const SyncStateData({
    required this.id,
    required this.deviceId,
    this.lastReferencePackageId,
    this.lastReferenceSyncAt,
    this.lastResultPushAt,
    this.lastResultPullAt,
    this.lastSuccessAt,
    this.lastError,
    required this.schemaVersion,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_id'] = Variable<String>(deviceId);
    if (!nullToAbsent || lastReferencePackageId != null) {
      map['last_reference_package_id'] = Variable<String>(
        lastReferencePackageId,
      );
    }
    if (!nullToAbsent || lastReferenceSyncAt != null) {
      map['last_reference_sync_at'] = Variable<String>(lastReferenceSyncAt);
    }
    if (!nullToAbsent || lastResultPushAt != null) {
      map['last_result_push_at'] = Variable<String>(lastResultPushAt);
    }
    if (!nullToAbsent || lastResultPullAt != null) {
      map['last_result_pull_at'] = Variable<String>(lastResultPullAt);
    }
    if (!nullToAbsent || lastSuccessAt != null) {
      map['last_success_at'] = Variable<String>(lastSuccessAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['schema_version'] = Variable<String>(schemaVersion);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      lastReferencePackageId: lastReferencePackageId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReferencePackageId),
      lastReferenceSyncAt: lastReferenceSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReferenceSyncAt),
      lastResultPushAt: lastResultPushAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastResultPushAt),
      lastResultPullAt: lastResultPullAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastResultPullAt),
      lastSuccessAt: lastSuccessAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      schemaVersion: Value(schemaVersion),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      id: serializer.fromJson<String>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      lastReferencePackageId: serializer.fromJson<String?>(
        json['lastReferencePackageId'],
      ),
      lastReferenceSyncAt: serializer.fromJson<String?>(
        json['lastReferenceSyncAt'],
      ),
      lastResultPushAt: serializer.fromJson<String?>(json['lastResultPushAt']),
      lastResultPullAt: serializer.fromJson<String?>(json['lastResultPullAt']),
      lastSuccessAt: serializer.fromJson<String?>(json['lastSuccessAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      schemaVersion: serializer.fromJson<String>(json['schemaVersion']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'lastReferencePackageId': serializer.toJson<String?>(
        lastReferencePackageId,
      ),
      'lastReferenceSyncAt': serializer.toJson<String?>(lastReferenceSyncAt),
      'lastResultPushAt': serializer.toJson<String?>(lastResultPushAt),
      'lastResultPullAt': serializer.toJson<String?>(lastResultPullAt),
      'lastSuccessAt': serializer.toJson<String?>(lastSuccessAt),
      'lastError': serializer.toJson<String?>(lastError),
      'schemaVersion': serializer.toJson<String>(schemaVersion),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  SyncStateData copyWith({
    String? id,
    String? deviceId,
    Value<String?> lastReferencePackageId = const Value.absent(),
    Value<String?> lastReferenceSyncAt = const Value.absent(),
    Value<String?> lastResultPushAt = const Value.absent(),
    Value<String?> lastResultPullAt = const Value.absent(),
    Value<String?> lastSuccessAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    String? schemaVersion,
    String? updatedAt,
  }) => SyncStateData(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    lastReferencePackageId: lastReferencePackageId.present
        ? lastReferencePackageId.value
        : this.lastReferencePackageId,
    lastReferenceSyncAt: lastReferenceSyncAt.present
        ? lastReferenceSyncAt.value
        : this.lastReferenceSyncAt,
    lastResultPushAt: lastResultPushAt.present
        ? lastResultPushAt.value
        : this.lastResultPushAt,
    lastResultPullAt: lastResultPullAt.present
        ? lastResultPullAt.value
        : this.lastResultPullAt,
    lastSuccessAt: lastSuccessAt.present
        ? lastSuccessAt.value
        : this.lastSuccessAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      lastReferencePackageId: data.lastReferencePackageId.present
          ? data.lastReferencePackageId.value
          : this.lastReferencePackageId,
      lastReferenceSyncAt: data.lastReferenceSyncAt.present
          ? data.lastReferenceSyncAt.value
          : this.lastReferenceSyncAt,
      lastResultPushAt: data.lastResultPushAt.present
          ? data.lastResultPushAt.value
          : this.lastResultPushAt,
      lastResultPullAt: data.lastResultPullAt.present
          ? data.lastResultPullAt.value
          : this.lastResultPullAt,
      lastSuccessAt: data.lastSuccessAt.present
          ? data.lastSuccessAt.value
          : this.lastSuccessAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('lastReferencePackageId: $lastReferencePackageId, ')
          ..write('lastReferenceSyncAt: $lastReferenceSyncAt, ')
          ..write('lastResultPushAt: $lastResultPushAt, ')
          ..write('lastResultPullAt: $lastResultPullAt, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('lastError: $lastError, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    lastReferencePackageId,
    lastReferenceSyncAt,
    lastResultPushAt,
    lastResultPullAt,
    lastSuccessAt,
    lastError,
    schemaVersion,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.lastReferencePackageId == this.lastReferencePackageId &&
          other.lastReferenceSyncAt == this.lastReferenceSyncAt &&
          other.lastResultPushAt == this.lastResultPushAt &&
          other.lastResultPullAt == this.lastResultPullAt &&
          other.lastSuccessAt == this.lastSuccessAt &&
          other.lastError == this.lastError &&
          other.schemaVersion == this.schemaVersion &&
          other.updatedAt == this.updatedAt);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<String> id;
  final Value<String> deviceId;
  final Value<String?> lastReferencePackageId;
  final Value<String?> lastReferenceSyncAt;
  final Value<String?> lastResultPushAt;
  final Value<String?> lastResultPullAt;
  final Value<String?> lastSuccessAt;
  final Value<String?> lastError;
  final Value<String> schemaVersion;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.lastReferencePackageId = const Value.absent(),
    this.lastReferenceSyncAt = const Value.absent(),
    this.lastResultPushAt = const Value.absent(),
    this.lastResultPullAt = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String id,
    required String deviceId,
    this.lastReferencePackageId = const Value.absent(),
    this.lastReferenceSyncAt = const Value.absent(),
    this.lastResultPushAt = const Value.absent(),
    this.lastResultPullAt = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    this.lastError = const Value.absent(),
    required String schemaVersion,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deviceId = Value(deviceId),
       schemaVersion = Value(schemaVersion),
       updatedAt = Value(updatedAt);
  static Insertable<SyncStateData> custom({
    Expression<String>? id,
    Expression<String>? deviceId,
    Expression<String>? lastReferencePackageId,
    Expression<String>? lastReferenceSyncAt,
    Expression<String>? lastResultPushAt,
    Expression<String>? lastResultPullAt,
    Expression<String>? lastSuccessAt,
    Expression<String>? lastError,
    Expression<String>? schemaVersion,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (lastReferencePackageId != null)
        'last_reference_package_id': lastReferencePackageId,
      if (lastReferenceSyncAt != null)
        'last_reference_sync_at': lastReferenceSyncAt,
      if (lastResultPushAt != null) 'last_result_push_at': lastResultPushAt,
      if (lastResultPullAt != null) 'last_result_pull_at': lastResultPullAt,
      if (lastSuccessAt != null) 'last_success_at': lastSuccessAt,
      if (lastError != null) 'last_error': lastError,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? id,
    Value<String>? deviceId,
    Value<String?>? lastReferencePackageId,
    Value<String?>? lastReferenceSyncAt,
    Value<String?>? lastResultPushAt,
    Value<String?>? lastResultPullAt,
    Value<String?>? lastSuccessAt,
    Value<String?>? lastError,
    Value<String>? schemaVersion,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      lastReferencePackageId:
          lastReferencePackageId ?? this.lastReferencePackageId,
      lastReferenceSyncAt: lastReferenceSyncAt ?? this.lastReferenceSyncAt,
      lastResultPushAt: lastResultPushAt ?? this.lastResultPushAt,
      lastResultPullAt: lastResultPullAt ?? this.lastResultPullAt,
      lastSuccessAt: lastSuccessAt ?? this.lastSuccessAt,
      lastError: lastError ?? this.lastError,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (lastReferencePackageId.present) {
      map['last_reference_package_id'] = Variable<String>(
        lastReferencePackageId.value,
      );
    }
    if (lastReferenceSyncAt.present) {
      map['last_reference_sync_at'] = Variable<String>(
        lastReferenceSyncAt.value,
      );
    }
    if (lastResultPushAt.present) {
      map['last_result_push_at'] = Variable<String>(lastResultPushAt.value);
    }
    if (lastResultPullAt.present) {
      map['last_result_pull_at'] = Variable<String>(lastResultPullAt.value);
    }
    if (lastSuccessAt.present) {
      map['last_success_at'] = Variable<String>(lastSuccessAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<String>(schemaVersion.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('lastReferencePackageId: $lastReferencePackageId, ')
          ..write('lastReferenceSyncAt: $lastReferenceSyncAt, ')
          ..write('lastResultPushAt: $lastResultPushAt, ')
          ..write('lastResultPullAt: $lastResultPullAt, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('lastError: $lastError, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageTypeMeta = const VerificationMeta(
    'packageType',
  );
  @override
  late final GeneratedColumn<String> packageType = GeneratedColumn<String>(
    'package_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<String> packageId = GeneratedColumn<String>(
    'package_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<String> nextAttemptAt = GeneratedColumn<String>(
    'next_attempt_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    direction,
    packageType,
    packageId,
    localPath,
    status,
    attemptCount,
    nextAttemptAt,
    lastError,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('package_type')) {
      context.handle(
        _packageTypeMeta,
        packageType.isAcceptableOrUnknown(
          data['package_type']!,
          _packageTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageTypeMeta);
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packageIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      packageType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_type'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String direction;
  final String packageType;
  final String packageId;
  final String localPath;
  final String status;
  final int attemptCount;
  final String? nextAttemptAt;
  final String? lastError;
  final String createdAt;
  final String updatedAt;
  const SyncQueueData({
    required this.id,
    required this.direction,
    required this.packageType,
    required this.packageId,
    required this.localPath,
    required this.status,
    required this.attemptCount,
    this.nextAttemptAt,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['direction'] = Variable<String>(direction);
    map['package_type'] = Variable<String>(packageType);
    map['package_id'] = Variable<String>(packageId);
    map['local_path'] = Variable<String>(localPath);
    map['status'] = Variable<String>(status);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<String>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      direction: Value(direction),
      packageType: Value(packageType),
      packageId: Value(packageId),
      localPath: Value(localPath),
      status: Value(status),
      attemptCount: Value(attemptCount),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      direction: serializer.fromJson<String>(json['direction']),
      packageType: serializer.fromJson<String>(json['packageType']),
      packageId: serializer.fromJson<String>(json['packageId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      status: serializer.fromJson<String>(json['status']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      nextAttemptAt: serializer.fromJson<String?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'direction': serializer.toJson<String>(direction),
      'packageType': serializer.toJson<String>(packageType),
      'packageId': serializer.toJson<String>(packageId),
      'localPath': serializer.toJson<String>(localPath),
      'status': serializer.toJson<String>(status),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'nextAttemptAt': serializer.toJson<String?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  SyncQueueData copyWith({
    String? id,
    String? direction,
    String? packageType,
    String? packageId,
    String? localPath,
    String? status,
    int? attemptCount,
    Value<String?> nextAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => SyncQueueData(
    id: id ?? this.id,
    direction: direction ?? this.direction,
    packageType: packageType ?? this.packageType,
    packageId: packageId ?? this.packageId,
    localPath: localPath ?? this.localPath,
    status: status ?? this.status,
    attemptCount: attemptCount ?? this.attemptCount,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      direction: data.direction.present ? data.direction.value : this.direction,
      packageType: data.packageType.present
          ? data.packageType.value
          : this.packageType,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      status: data.status.present ? data.status.value : this.status,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('direction: $direction, ')
          ..write('packageType: $packageType, ')
          ..write('packageId: $packageId, ')
          ..write('localPath: $localPath, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    direction,
    packageType,
    packageId,
    localPath,
    status,
    attemptCount,
    nextAttemptAt,
    lastError,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.direction == this.direction &&
          other.packageType == this.packageType &&
          other.packageId == this.packageId &&
          other.localPath == this.localPath &&
          other.status == this.status &&
          other.attemptCount == this.attemptCount &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> direction;
  final Value<String> packageType;
  final Value<String> packageId;
  final Value<String> localPath;
  final Value<String> status;
  final Value<int> attemptCount;
  final Value<String?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.direction = const Value.absent(),
    this.packageType = const Value.absent(),
    this.packageId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String direction,
    required String packageType,
    required String packageId,
    required String localPath,
    required String status,
    this.attemptCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       direction = Value(direction),
       packageType = Value(packageType),
       packageId = Value(packageId),
       localPath = Value(localPath),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? direction,
    Expression<String>? packageType,
    Expression<String>? packageId,
    Expression<String>? localPath,
    Expression<String>? status,
    Expression<int>? attemptCount,
    Expression<String>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (direction != null) 'direction': direction,
      if (packageType != null) 'package_type': packageType,
      if (packageId != null) 'package_id': packageId,
      if (localPath != null) 'local_path': localPath,
      if (status != null) 'status': status,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? direction,
    Value<String>? packageType,
    Value<String>? packageId,
    Value<String>? localPath,
    Value<String>? status,
    Value<int>? attemptCount,
    Value<String?>? nextAttemptAt,
    Value<String?>? lastError,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      direction: direction ?? this.direction,
      packageType: packageType ?? this.packageType,
      packageId: packageId ?? this.packageId,
      localPath: localPath ?? this.localPath,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (packageType.present) {
      map['package_type'] = Variable<String>(packageType.value);
    }
    if (packageId.present) {
      map['package_id'] = Variable<String>(packageId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<String>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('direction: $direction, ')
          ..write('packageType: $packageType, ')
          ..write('packageId: $packageId, ')
          ..write('localPath: $localPath, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocksTable extends Locks with TableInfo<$LocksTable, Lock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productObjectIdMeta = const VerificationMeta(
    'productObjectId',
  );
  @override
  late final GeneratedColumn<String> productObjectId = GeneratedColumn<String>(
    'product_object_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteLockKeyMeta = const VerificationMeta(
    'remoteLockKey',
  );
  @override
  late final GeneratedColumn<String> remoteLockKey = GeneratedColumn<String>(
    'remote_lock_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acquiredAtMeta = const VerificationMeta(
    'acquiredAt',
  );
  @override
  late final GeneratedColumn<String> acquiredAt = GeneratedColumn<String>(
    'acquired_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<String> expiresAt = GeneratedColumn<String>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _releasedAtMeta = const VerificationMeta(
    'releasedAt',
  );
  @override
  late final GeneratedColumn<String> releasedAt = GeneratedColumn<String>(
    'released_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productObjectId,
    remoteLockKey,
    deviceId,
    userId,
    status,
    acquiredAt,
    expiresAt,
    releasedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_object_id')) {
      context.handle(
        _productObjectIdMeta,
        productObjectId.isAcceptableOrUnknown(
          data['product_object_id']!,
          _productObjectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productObjectIdMeta);
    }
    if (data.containsKey('remote_lock_key')) {
      context.handle(
        _remoteLockKeyMeta,
        remoteLockKey.isAcceptableOrUnknown(
          data['remote_lock_key']!,
          _remoteLockKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remoteLockKeyMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('acquired_at')) {
      context.handle(
        _acquiredAtMeta,
        acquiredAt.isAcceptableOrUnknown(data['acquired_at']!, _acquiredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_acquiredAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('released_at')) {
      context.handle(
        _releasedAtMeta,
        releasedAt.isAcceptableOrUnknown(data['released_at']!, _releasedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productObjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_object_id'],
      )!,
      remoteLockKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_lock_key'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      acquiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}acquired_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expires_at'],
      )!,
      releasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}released_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocksTable createAlias(String alias) {
    return $LocksTable(attachedDatabase, alias);
  }
}

class Lock extends DataClass implements Insertable<Lock> {
  final String id;
  final String productObjectId;
  final String remoteLockKey;
  final String deviceId;
  final String userId;
  final String status;
  final String acquiredAt;
  final String expiresAt;
  final String? releasedAt;
  final String createdAt;
  final String updatedAt;
  const Lock({
    required this.id,
    required this.productObjectId,
    required this.remoteLockKey,
    required this.deviceId,
    required this.userId,
    required this.status,
    required this.acquiredAt,
    required this.expiresAt,
    this.releasedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_object_id'] = Variable<String>(productObjectId);
    map['remote_lock_key'] = Variable<String>(remoteLockKey);
    map['device_id'] = Variable<String>(deviceId);
    map['user_id'] = Variable<String>(userId);
    map['status'] = Variable<String>(status);
    map['acquired_at'] = Variable<String>(acquiredAt);
    map['expires_at'] = Variable<String>(expiresAt);
    if (!nullToAbsent || releasedAt != null) {
      map['released_at'] = Variable<String>(releasedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  LocksCompanion toCompanion(bool nullToAbsent) {
    return LocksCompanion(
      id: Value(id),
      productObjectId: Value(productObjectId),
      remoteLockKey: Value(remoteLockKey),
      deviceId: Value(deviceId),
      userId: Value(userId),
      status: Value(status),
      acquiredAt: Value(acquiredAt),
      expiresAt: Value(expiresAt),
      releasedAt: releasedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(releasedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Lock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lock(
      id: serializer.fromJson<String>(json['id']),
      productObjectId: serializer.fromJson<String>(json['productObjectId']),
      remoteLockKey: serializer.fromJson<String>(json['remoteLockKey']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      userId: serializer.fromJson<String>(json['userId']),
      status: serializer.fromJson<String>(json['status']),
      acquiredAt: serializer.fromJson<String>(json['acquiredAt']),
      expiresAt: serializer.fromJson<String>(json['expiresAt']),
      releasedAt: serializer.fromJson<String?>(json['releasedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productObjectId': serializer.toJson<String>(productObjectId),
      'remoteLockKey': serializer.toJson<String>(remoteLockKey),
      'deviceId': serializer.toJson<String>(deviceId),
      'userId': serializer.toJson<String>(userId),
      'status': serializer.toJson<String>(status),
      'acquiredAt': serializer.toJson<String>(acquiredAt),
      'expiresAt': serializer.toJson<String>(expiresAt),
      'releasedAt': serializer.toJson<String?>(releasedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Lock copyWith({
    String? id,
    String? productObjectId,
    String? remoteLockKey,
    String? deviceId,
    String? userId,
    String? status,
    String? acquiredAt,
    String? expiresAt,
    Value<String?> releasedAt = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => Lock(
    id: id ?? this.id,
    productObjectId: productObjectId ?? this.productObjectId,
    remoteLockKey: remoteLockKey ?? this.remoteLockKey,
    deviceId: deviceId ?? this.deviceId,
    userId: userId ?? this.userId,
    status: status ?? this.status,
    acquiredAt: acquiredAt ?? this.acquiredAt,
    expiresAt: expiresAt ?? this.expiresAt,
    releasedAt: releasedAt.present ? releasedAt.value : this.releasedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Lock copyWithCompanion(LocksCompanion data) {
    return Lock(
      id: data.id.present ? data.id.value : this.id,
      productObjectId: data.productObjectId.present
          ? data.productObjectId.value
          : this.productObjectId,
      remoteLockKey: data.remoteLockKey.present
          ? data.remoteLockKey.value
          : this.remoteLockKey,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      userId: data.userId.present ? data.userId.value : this.userId,
      status: data.status.present ? data.status.value : this.status,
      acquiredAt: data.acquiredAt.present
          ? data.acquiredAt.value
          : this.acquiredAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      releasedAt: data.releasedAt.present
          ? data.releasedAt.value
          : this.releasedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lock(')
          ..write('id: $id, ')
          ..write('productObjectId: $productObjectId, ')
          ..write('remoteLockKey: $remoteLockKey, ')
          ..write('deviceId: $deviceId, ')
          ..write('userId: $userId, ')
          ..write('status: $status, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('releasedAt: $releasedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productObjectId,
    remoteLockKey,
    deviceId,
    userId,
    status,
    acquiredAt,
    expiresAt,
    releasedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lock &&
          other.id == this.id &&
          other.productObjectId == this.productObjectId &&
          other.remoteLockKey == this.remoteLockKey &&
          other.deviceId == this.deviceId &&
          other.userId == this.userId &&
          other.status == this.status &&
          other.acquiredAt == this.acquiredAt &&
          other.expiresAt == this.expiresAt &&
          other.releasedAt == this.releasedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocksCompanion extends UpdateCompanion<Lock> {
  final Value<String> id;
  final Value<String> productObjectId;
  final Value<String> remoteLockKey;
  final Value<String> deviceId;
  final Value<String> userId;
  final Value<String> status;
  final Value<String> acquiredAt;
  final Value<String> expiresAt;
  final Value<String?> releasedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const LocksCompanion({
    this.id = const Value.absent(),
    this.productObjectId = const Value.absent(),
    this.remoteLockKey = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.userId = const Value.absent(),
    this.status = const Value.absent(),
    this.acquiredAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.releasedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocksCompanion.insert({
    required String id,
    required String productObjectId,
    required String remoteLockKey,
    required String deviceId,
    required String userId,
    required String status,
    required String acquiredAt,
    required String expiresAt,
    this.releasedAt = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productObjectId = Value(productObjectId),
       remoteLockKey = Value(remoteLockKey),
       deviceId = Value(deviceId),
       userId = Value(userId),
       status = Value(status),
       acquiredAt = Value(acquiredAt),
       expiresAt = Value(expiresAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Lock> custom({
    Expression<String>? id,
    Expression<String>? productObjectId,
    Expression<String>? remoteLockKey,
    Expression<String>? deviceId,
    Expression<String>? userId,
    Expression<String>? status,
    Expression<String>? acquiredAt,
    Expression<String>? expiresAt,
    Expression<String>? releasedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productObjectId != null) 'product_object_id': productObjectId,
      if (remoteLockKey != null) 'remote_lock_key': remoteLockKey,
      if (deviceId != null) 'device_id': deviceId,
      if (userId != null) 'user_id': userId,
      if (status != null) 'status': status,
      if (acquiredAt != null) 'acquired_at': acquiredAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (releasedAt != null) 'released_at': releasedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocksCompanion copyWith({
    Value<String>? id,
    Value<String>? productObjectId,
    Value<String>? remoteLockKey,
    Value<String>? deviceId,
    Value<String>? userId,
    Value<String>? status,
    Value<String>? acquiredAt,
    Value<String>? expiresAt,
    Value<String?>? releasedAt,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocksCompanion(
      id: id ?? this.id,
      productObjectId: productObjectId ?? this.productObjectId,
      remoteLockKey: remoteLockKey ?? this.remoteLockKey,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      expiresAt: expiresAt ?? this.expiresAt,
      releasedAt: releasedAt ?? this.releasedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productObjectId.present) {
      map['product_object_id'] = Variable<String>(productObjectId.value);
    }
    if (remoteLockKey.present) {
      map['remote_lock_key'] = Variable<String>(remoteLockKey.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (acquiredAt.present) {
      map['acquired_at'] = Variable<String>(acquiredAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<String>(expiresAt.value);
    }
    if (releasedAt.present) {
      map['released_at'] = Variable<String>(releasedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocksCompanion(')
          ..write('id: $id, ')
          ..write('productObjectId: $productObjectId, ')
          ..write('remoteLockKey: $remoteLockKey, ')
          ..write('deviceId: $deviceId, ')
          ..write('userId: $userId, ')
          ..write('status: $status, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('releasedAt: $releasedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ComponentImagesTable extends ComponentImages
    with TableInfo<$ComponentImagesTable, ComponentImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComponentImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaKeyMeta = const VerificationMeta(
    'mediaKey',
  );
  @override
  late final GeneratedColumn<String> mediaKey = GeneratedColumn<String>(
    'media_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remotePathMeta = const VerificationMeta(
    'remotePath',
  );
  @override
  late final GeneratedColumn<String> remotePath = GeneratedColumn<String>(
    'remote_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checksumMeta = const VerificationMeta(
    'checksum',
  );
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    componentId,
    fileName,
    mediaKey,
    localPath,
    remotePath,
    checksum,
    mimeType,
    sortOrder,
    width,
    height,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'component_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComponentImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_componentIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('media_key')) {
      context.handle(
        _mediaKeyMeta,
        mediaKey.isAcceptableOrUnknown(data['media_key']!, _mediaKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaKeyMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('remote_path')) {
      context.handle(
        _remotePathMeta,
        remotePath.isAcceptableOrUnknown(data['remote_path']!, _remotePathMeta),
      );
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _checksumMeta,
        checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta),
      );
    } else if (isInserting) {
      context.missing(_checksumMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComponentImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComponentImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      mediaKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_key'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      remotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_path'],
      ),
      checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ComponentImagesTable createAlias(String alias) {
    return $ComponentImagesTable(attachedDatabase, alias);
  }
}

class ComponentImage extends DataClass implements Insertable<ComponentImage> {
  final String id;
  final String componentId;
  final String fileName;
  final String mediaKey;
  final String? localPath;
  final String? remotePath;
  final String checksum;
  final String mimeType;
  final int sortOrder;
  final int? width;
  final int? height;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;
  const ComponentImage({
    required this.id,
    required this.componentId,
    required this.fileName,
    required this.mediaKey,
    this.localPath,
    this.remotePath,
    required this.checksum,
    required this.mimeType,
    required this.sortOrder,
    this.width,
    this.height,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['component_id'] = Variable<String>(componentId);
    map['file_name'] = Variable<String>(fileName);
    map['media_key'] = Variable<String>(mediaKey);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || remotePath != null) {
      map['remote_path'] = Variable<String>(remotePath);
    }
    map['checksum'] = Variable<String>(checksum);
    map['mime_type'] = Variable<String>(mimeType);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ComponentImagesCompanion toCompanion(bool nullToAbsent) {
    return ComponentImagesCompanion(
      id: Value(id),
      componentId: Value(componentId),
      fileName: Value(fileName),
      mediaKey: Value(mediaKey),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      remotePath: remotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(remotePath),
      checksum: Value(checksum),
      mimeType: Value(mimeType),
      sortOrder: Value(sortOrder),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory ComponentImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComponentImage(
      id: serializer.fromJson<String>(json['id']),
      componentId: serializer.fromJson<String>(json['componentId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      mediaKey: serializer.fromJson<String>(json['mediaKey']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      remotePath: serializer.fromJson<String?>(json['remotePath']),
      checksum: serializer.fromJson<String>(json['checksum']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'componentId': serializer.toJson<String>(componentId),
      'fileName': serializer.toJson<String>(fileName),
      'mediaKey': serializer.toJson<String>(mediaKey),
      'localPath': serializer.toJson<String?>(localPath),
      'remotePath': serializer.toJson<String?>(remotePath),
      'checksum': serializer.toJson<String>(checksum),
      'mimeType': serializer.toJson<String>(mimeType),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ComponentImage copyWith({
    String? id,
    String? componentId,
    String? fileName,
    String? mediaKey,
    Value<String?> localPath = const Value.absent(),
    Value<String?> remotePath = const Value.absent(),
    String? checksum,
    String? mimeType,
    int? sortOrder,
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    int? version,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
    bool? isDeleted,
  }) => ComponentImage(
    id: id ?? this.id,
    componentId: componentId ?? this.componentId,
    fileName: fileName ?? this.fileName,
    mediaKey: mediaKey ?? this.mediaKey,
    localPath: localPath.present ? localPath.value : this.localPath,
    remotePath: remotePath.present ? remotePath.value : this.remotePath,
    checksum: checksum ?? this.checksum,
    mimeType: mimeType ?? this.mimeType,
    sortOrder: sortOrder ?? this.sortOrder,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  ComponentImage copyWithCompanion(ComponentImagesCompanion data) {
    return ComponentImage(
      id: data.id.present ? data.id.value : this.id,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mediaKey: data.mediaKey.present ? data.mediaKey.value : this.mediaKey,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      remotePath: data.remotePath.present
          ? data.remotePath.value
          : this.remotePath,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComponentImage(')
          ..write('id: $id, ')
          ..write('componentId: $componentId, ')
          ..write('fileName: $fileName, ')
          ..write('mediaKey: $mediaKey, ')
          ..write('localPath: $localPath, ')
          ..write('remotePath: $remotePath, ')
          ..write('checksum: $checksum, ')
          ..write('mimeType: $mimeType, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    componentId,
    fileName,
    mediaKey,
    localPath,
    remotePath,
    checksum,
    mimeType,
    sortOrder,
    width,
    height,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComponentImage &&
          other.id == this.id &&
          other.componentId == this.componentId &&
          other.fileName == this.fileName &&
          other.mediaKey == this.mediaKey &&
          other.localPath == this.localPath &&
          other.remotePath == this.remotePath &&
          other.checksum == this.checksum &&
          other.mimeType == this.mimeType &&
          other.sortOrder == this.sortOrder &&
          other.width == this.width &&
          other.height == this.height &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDeleted == this.isDeleted);
}

class ComponentImagesCompanion extends UpdateCompanion<ComponentImage> {
  final Value<String> id;
  final Value<String> componentId;
  final Value<String> fileName;
  final Value<String> mediaKey;
  final Value<String?> localPath;
  final Value<String?> remotePath;
  final Value<String> checksum;
  final Value<String> mimeType;
  final Value<int> sortOrder;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ComponentImagesCompanion({
    this.id = const Value.absent(),
    this.componentId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mediaKey = const Value.absent(),
    this.localPath = const Value.absent(),
    this.remotePath = const Value.absent(),
    this.checksum = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComponentImagesCompanion.insert({
    required String id,
    required String componentId,
    required String fileName,
    required String mediaKey,
    this.localPath = const Value.absent(),
    this.remotePath = const Value.absent(),
    required String checksum,
    required String mimeType,
    this.sortOrder = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       componentId = Value(componentId),
       fileName = Value(fileName),
       mediaKey = Value(mediaKey),
       checksum = Value(checksum),
       mimeType = Value(mimeType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ComponentImage> custom({
    Expression<String>? id,
    Expression<String>? componentId,
    Expression<String>? fileName,
    Expression<String>? mediaKey,
    Expression<String>? localPath,
    Expression<String>? remotePath,
    Expression<String>? checksum,
    Expression<String>? mimeType,
    Expression<int>? sortOrder,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (componentId != null) 'component_id': componentId,
      if (fileName != null) 'file_name': fileName,
      if (mediaKey != null) 'media_key': mediaKey,
      if (localPath != null) 'local_path': localPath,
      if (remotePath != null) 'remote_path': remotePath,
      if (checksum != null) 'checksum': checksum,
      if (mimeType != null) 'mime_type': mimeType,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComponentImagesCompanion copyWith({
    Value<String>? id,
    Value<String>? componentId,
    Value<String>? fileName,
    Value<String>? mediaKey,
    Value<String?>? localPath,
    Value<String?>? remotePath,
    Value<String>? checksum,
    Value<String>? mimeType,
    Value<int>? sortOrder,
    Value<int?>? width,
    Value<int?>? height,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return ComponentImagesCompanion(
      id: id ?? this.id,
      componentId: componentId ?? this.componentId,
      fileName: fileName ?? this.fileName,
      mediaKey: mediaKey ?? this.mediaKey,
      localPath: localPath ?? this.localPath,
      remotePath: remotePath ?? this.remotePath,
      checksum: checksum ?? this.checksum,
      mimeType: mimeType ?? this.mimeType,
      sortOrder: sortOrder ?? this.sortOrder,
      width: width ?? this.width,
      height: height ?? this.height,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mediaKey.present) {
      map['media_key'] = Variable<String>(mediaKey.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (remotePath.present) {
      map['remote_path'] = Variable<String>(remotePath.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComponentImagesCompanion(')
          ..write('id: $id, ')
          ..write('componentId: $componentId, ')
          ..write('fileName: $fileName, ')
          ..write('mediaKey: $mediaKey, ')
          ..write('localPath: $localPath, ')
          ..write('remotePath: $remotePath, ')
          ..write('checksum: $checksum, ')
          ..write('mimeType: $mimeType, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionsTable extends Inspections
    with TableInfo<$InspectionsTable, Inspection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productObjectIdMeta = const VerificationMeta(
    'productObjectId',
  );
  @override
  late final GeneratedColumn<String> productObjectId = GeneratedColumn<String>(
    'product_object_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetObjectIdMeta = const VerificationMeta(
    'targetObjectId',
  );
  @override
  late final GeneratedColumn<String> targetObjectId = GeneratedColumn<String>(
    'target_object_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<String> startedAt = GeneratedColumn<String>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<String> completedAt = GeneratedColumn<String>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceReferencePackageIdMeta =
      const VerificationMeta('sourceReferencePackageId');
  @override
  late final GeneratedColumn<String> sourceReferencePackageId =
      GeneratedColumn<String>(
        'source_reference_package_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceReferenceVersionMeta =
      const VerificationMeta('sourceReferenceVersion');
  @override
  late final GeneratedColumn<String> sourceReferenceVersion =
      GeneratedColumn<String>(
        'source_reference_version',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _pdfLocalPathMeta = const VerificationMeta(
    'pdfLocalPath',
  );
  @override
  late final GeneratedColumn<String> pdfLocalPath = GeneratedColumn<String>(
    'pdf_local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pdfChecksumMeta = const VerificationMeta(
    'pdfChecksum',
  );
  @override
  late final GeneratedColumn<String> pdfChecksum = GeneratedColumn<String>(
    'pdf_checksum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conflictReasonMeta = const VerificationMeta(
    'conflictReason',
  );
  @override
  late final GeneratedColumn<String> conflictReason = GeneratedColumn<String>(
    'conflict_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    userId,
    productObjectId,
    targetObjectId,
    startedAt,
    completedAt,
    status,
    syncStatus,
    sourceReferencePackageId,
    sourceReferenceVersion,
    pdfLocalPath,
    pdfChecksum,
    conflictReason,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Inspection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('product_object_id')) {
      context.handle(
        _productObjectIdMeta,
        productObjectId.isAcceptableOrUnknown(
          data['product_object_id']!,
          _productObjectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productObjectIdMeta);
    }
    if (data.containsKey('target_object_id')) {
      context.handle(
        _targetObjectIdMeta,
        targetObjectId.isAcceptableOrUnknown(
          data['target_object_id']!,
          _targetObjectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetObjectIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('source_reference_package_id')) {
      context.handle(
        _sourceReferencePackageIdMeta,
        sourceReferencePackageId.isAcceptableOrUnknown(
          data['source_reference_package_id']!,
          _sourceReferencePackageIdMeta,
        ),
      );
    }
    if (data.containsKey('source_reference_version')) {
      context.handle(
        _sourceReferenceVersionMeta,
        sourceReferenceVersion.isAcceptableOrUnknown(
          data['source_reference_version']!,
          _sourceReferenceVersionMeta,
        ),
      );
    }
    if (data.containsKey('pdf_local_path')) {
      context.handle(
        _pdfLocalPathMeta,
        pdfLocalPath.isAcceptableOrUnknown(
          data['pdf_local_path']!,
          _pdfLocalPathMeta,
        ),
      );
    }
    if (data.containsKey('pdf_checksum')) {
      context.handle(
        _pdfChecksumMeta,
        pdfChecksum.isAcceptableOrUnknown(
          data['pdf_checksum']!,
          _pdfChecksumMeta,
        ),
      );
    }
    if (data.containsKey('conflict_reason')) {
      context.handle(
        _conflictReasonMeta,
        conflictReason.isAcceptableOrUnknown(
          data['conflict_reason']!,
          _conflictReasonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inspection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inspection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      productObjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_object_id'],
      )!,
      targetObjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_object_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      sourceReferencePackageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference_package_id'],
      ),
      sourceReferenceVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference_version'],
      ),
      pdfLocalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_local_path'],
      ),
      pdfChecksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_checksum'],
      ),
      conflictReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InspectionsTable createAlias(String alias) {
    return $InspectionsTable(attachedDatabase, alias);
  }
}

class Inspection extends DataClass implements Insertable<Inspection> {
  final String id;
  final String deviceId;
  final String userId;
  final String productObjectId;
  final String targetObjectId;
  final String startedAt;
  final String? completedAt;
  final String status;
  final String syncStatus;
  final String? sourceReferencePackageId;
  final String? sourceReferenceVersion;
  final String? pdfLocalPath;
  final String? pdfChecksum;
  final String? conflictReason;
  final String createdAt;
  final String updatedAt;
  const Inspection({
    required this.id,
    required this.deviceId,
    required this.userId,
    required this.productObjectId,
    required this.targetObjectId,
    required this.startedAt,
    this.completedAt,
    required this.status,
    required this.syncStatus,
    this.sourceReferencePackageId,
    this.sourceReferenceVersion,
    this.pdfLocalPath,
    this.pdfChecksum,
    this.conflictReason,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['user_id'] = Variable<String>(userId);
    map['product_object_id'] = Variable<String>(productObjectId);
    map['target_object_id'] = Variable<String>(targetObjectId);
    map['started_at'] = Variable<String>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<String>(completedAt);
    }
    map['status'] = Variable<String>(status);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || sourceReferencePackageId != null) {
      map['source_reference_package_id'] = Variable<String>(
        sourceReferencePackageId,
      );
    }
    if (!nullToAbsent || sourceReferenceVersion != null) {
      map['source_reference_version'] = Variable<String>(
        sourceReferenceVersion,
      );
    }
    if (!nullToAbsent || pdfLocalPath != null) {
      map['pdf_local_path'] = Variable<String>(pdfLocalPath);
    }
    if (!nullToAbsent || pdfChecksum != null) {
      map['pdf_checksum'] = Variable<String>(pdfChecksum);
    }
    if (!nullToAbsent || conflictReason != null) {
      map['conflict_reason'] = Variable<String>(conflictReason);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  InspectionsCompanion toCompanion(bool nullToAbsent) {
    return InspectionsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      userId: Value(userId),
      productObjectId: Value(productObjectId),
      targetObjectId: Value(targetObjectId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      status: Value(status),
      syncStatus: Value(syncStatus),
      sourceReferencePackageId: sourceReferencePackageId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReferencePackageId),
      sourceReferenceVersion: sourceReferenceVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReferenceVersion),
      pdfLocalPath: pdfLocalPath == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfLocalPath),
      pdfChecksum: pdfChecksum == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfChecksum),
      conflictReason: conflictReason == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictReason),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Inspection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Inspection(
      id: serializer.fromJson<String>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      userId: serializer.fromJson<String>(json['userId']),
      productObjectId: serializer.fromJson<String>(json['productObjectId']),
      targetObjectId: serializer.fromJson<String>(json['targetObjectId']),
      startedAt: serializer.fromJson<String>(json['startedAt']),
      completedAt: serializer.fromJson<String?>(json['completedAt']),
      status: serializer.fromJson<String>(json['status']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      sourceReferencePackageId: serializer.fromJson<String?>(
        json['sourceReferencePackageId'],
      ),
      sourceReferenceVersion: serializer.fromJson<String?>(
        json['sourceReferenceVersion'],
      ),
      pdfLocalPath: serializer.fromJson<String?>(json['pdfLocalPath']),
      pdfChecksum: serializer.fromJson<String?>(json['pdfChecksum']),
      conflictReason: serializer.fromJson<String?>(json['conflictReason']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'userId': serializer.toJson<String>(userId),
      'productObjectId': serializer.toJson<String>(productObjectId),
      'targetObjectId': serializer.toJson<String>(targetObjectId),
      'startedAt': serializer.toJson<String>(startedAt),
      'completedAt': serializer.toJson<String?>(completedAt),
      'status': serializer.toJson<String>(status),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'sourceReferencePackageId': serializer.toJson<String?>(
        sourceReferencePackageId,
      ),
      'sourceReferenceVersion': serializer.toJson<String?>(
        sourceReferenceVersion,
      ),
      'pdfLocalPath': serializer.toJson<String?>(pdfLocalPath),
      'pdfChecksum': serializer.toJson<String?>(pdfChecksum),
      'conflictReason': serializer.toJson<String?>(conflictReason),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Inspection copyWith({
    String? id,
    String? deviceId,
    String? userId,
    String? productObjectId,
    String? targetObjectId,
    String? startedAt,
    Value<String?> completedAt = const Value.absent(),
    String? status,
    String? syncStatus,
    Value<String?> sourceReferencePackageId = const Value.absent(),
    Value<String?> sourceReferenceVersion = const Value.absent(),
    Value<String?> pdfLocalPath = const Value.absent(),
    Value<String?> pdfChecksum = const Value.absent(),
    Value<String?> conflictReason = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => Inspection(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    userId: userId ?? this.userId,
    productObjectId: productObjectId ?? this.productObjectId,
    targetObjectId: targetObjectId ?? this.targetObjectId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    status: status ?? this.status,
    syncStatus: syncStatus ?? this.syncStatus,
    sourceReferencePackageId: sourceReferencePackageId.present
        ? sourceReferencePackageId.value
        : this.sourceReferencePackageId,
    sourceReferenceVersion: sourceReferenceVersion.present
        ? sourceReferenceVersion.value
        : this.sourceReferenceVersion,
    pdfLocalPath: pdfLocalPath.present ? pdfLocalPath.value : this.pdfLocalPath,
    pdfChecksum: pdfChecksum.present ? pdfChecksum.value : this.pdfChecksum,
    conflictReason: conflictReason.present
        ? conflictReason.value
        : this.conflictReason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Inspection copyWithCompanion(InspectionsCompanion data) {
    return Inspection(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      userId: data.userId.present ? data.userId.value : this.userId,
      productObjectId: data.productObjectId.present
          ? data.productObjectId.value
          : this.productObjectId,
      targetObjectId: data.targetObjectId.present
          ? data.targetObjectId.value
          : this.targetObjectId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      status: data.status.present ? data.status.value : this.status,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      sourceReferencePackageId: data.sourceReferencePackageId.present
          ? data.sourceReferencePackageId.value
          : this.sourceReferencePackageId,
      sourceReferenceVersion: data.sourceReferenceVersion.present
          ? data.sourceReferenceVersion.value
          : this.sourceReferenceVersion,
      pdfLocalPath: data.pdfLocalPath.present
          ? data.pdfLocalPath.value
          : this.pdfLocalPath,
      pdfChecksum: data.pdfChecksum.present
          ? data.pdfChecksum.value
          : this.pdfChecksum,
      conflictReason: data.conflictReason.present
          ? data.conflictReason.value
          : this.conflictReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inspection(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('userId: $userId, ')
          ..write('productObjectId: $productObjectId, ')
          ..write('targetObjectId: $targetObjectId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('sourceReferencePackageId: $sourceReferencePackageId, ')
          ..write('sourceReferenceVersion: $sourceReferenceVersion, ')
          ..write('pdfLocalPath: $pdfLocalPath, ')
          ..write('pdfChecksum: $pdfChecksum, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    userId,
    productObjectId,
    targetObjectId,
    startedAt,
    completedAt,
    status,
    syncStatus,
    sourceReferencePackageId,
    sourceReferenceVersion,
    pdfLocalPath,
    pdfChecksum,
    conflictReason,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inspection &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.userId == this.userId &&
          other.productObjectId == this.productObjectId &&
          other.targetObjectId == this.targetObjectId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.status == this.status &&
          other.syncStatus == this.syncStatus &&
          other.sourceReferencePackageId == this.sourceReferencePackageId &&
          other.sourceReferenceVersion == this.sourceReferenceVersion &&
          other.pdfLocalPath == this.pdfLocalPath &&
          other.pdfChecksum == this.pdfChecksum &&
          other.conflictReason == this.conflictReason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InspectionsCompanion extends UpdateCompanion<Inspection> {
  final Value<String> id;
  final Value<String> deviceId;
  final Value<String> userId;
  final Value<String> productObjectId;
  final Value<String> targetObjectId;
  final Value<String> startedAt;
  final Value<String?> completedAt;
  final Value<String> status;
  final Value<String> syncStatus;
  final Value<String?> sourceReferencePackageId;
  final Value<String?> sourceReferenceVersion;
  final Value<String?> pdfLocalPath;
  final Value<String?> pdfChecksum;
  final Value<String?> conflictReason;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const InspectionsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.userId = const Value.absent(),
    this.productObjectId = const Value.absent(),
    this.targetObjectId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.sourceReferencePackageId = const Value.absent(),
    this.sourceReferenceVersion = const Value.absent(),
    this.pdfLocalPath = const Value.absent(),
    this.pdfChecksum = const Value.absent(),
    this.conflictReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionsCompanion.insert({
    required String id,
    required String deviceId,
    required String userId,
    required String productObjectId,
    required String targetObjectId,
    required String startedAt,
    this.completedAt = const Value.absent(),
    required String status,
    required String syncStatus,
    this.sourceReferencePackageId = const Value.absent(),
    this.sourceReferenceVersion = const Value.absent(),
    this.pdfLocalPath = const Value.absent(),
    this.pdfChecksum = const Value.absent(),
    this.conflictReason = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deviceId = Value(deviceId),
       userId = Value(userId),
       productObjectId = Value(productObjectId),
       targetObjectId = Value(targetObjectId),
       startedAt = Value(startedAt),
       status = Value(status),
       syncStatus = Value(syncStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Inspection> custom({
    Expression<String>? id,
    Expression<String>? deviceId,
    Expression<String>? userId,
    Expression<String>? productObjectId,
    Expression<String>? targetObjectId,
    Expression<String>? startedAt,
    Expression<String>? completedAt,
    Expression<String>? status,
    Expression<String>? syncStatus,
    Expression<String>? sourceReferencePackageId,
    Expression<String>? sourceReferenceVersion,
    Expression<String>? pdfLocalPath,
    Expression<String>? pdfChecksum,
    Expression<String>? conflictReason,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (userId != null) 'user_id': userId,
      if (productObjectId != null) 'product_object_id': productObjectId,
      if (targetObjectId != null) 'target_object_id': targetObjectId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (status != null) 'status': status,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (sourceReferencePackageId != null)
        'source_reference_package_id': sourceReferencePackageId,
      if (sourceReferenceVersion != null)
        'source_reference_version': sourceReferenceVersion,
      if (pdfLocalPath != null) 'pdf_local_path': pdfLocalPath,
      if (pdfChecksum != null) 'pdf_checksum': pdfChecksum,
      if (conflictReason != null) 'conflict_reason': conflictReason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? deviceId,
    Value<String>? userId,
    Value<String>? productObjectId,
    Value<String>? targetObjectId,
    Value<String>? startedAt,
    Value<String?>? completedAt,
    Value<String>? status,
    Value<String>? syncStatus,
    Value<String?>? sourceReferencePackageId,
    Value<String?>? sourceReferenceVersion,
    Value<String?>? pdfLocalPath,
    Value<String?>? pdfChecksum,
    Value<String?>? conflictReason,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return InspectionsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      productObjectId: productObjectId ?? this.productObjectId,
      targetObjectId: targetObjectId ?? this.targetObjectId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      sourceReferencePackageId:
          sourceReferencePackageId ?? this.sourceReferencePackageId,
      sourceReferenceVersion:
          sourceReferenceVersion ?? this.sourceReferenceVersion,
      pdfLocalPath: pdfLocalPath ?? this.pdfLocalPath,
      pdfChecksum: pdfChecksum ?? this.pdfChecksum,
      conflictReason: conflictReason ?? this.conflictReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (productObjectId.present) {
      map['product_object_id'] = Variable<String>(productObjectId.value);
    }
    if (targetObjectId.present) {
      map['target_object_id'] = Variable<String>(targetObjectId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<String>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<String>(completedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (sourceReferencePackageId.present) {
      map['source_reference_package_id'] = Variable<String>(
        sourceReferencePackageId.value,
      );
    }
    if (sourceReferenceVersion.present) {
      map['source_reference_version'] = Variable<String>(
        sourceReferenceVersion.value,
      );
    }
    if (pdfLocalPath.present) {
      map['pdf_local_path'] = Variable<String>(pdfLocalPath.value);
    }
    if (pdfChecksum.present) {
      map['pdf_checksum'] = Variable<String>(pdfChecksum.value);
    }
    if (conflictReason.present) {
      map['conflict_reason'] = Variable<String>(conflictReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('userId: $userId, ')
          ..write('productObjectId: $productObjectId, ')
          ..write('targetObjectId: $targetObjectId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('sourceReferencePackageId: $sourceReferencePackageId, ')
          ..write('sourceReferenceVersion: $sourceReferenceVersion, ')
          ..write('pdfLocalPath: $pdfLocalPath, ')
          ..write('pdfChecksum: $pdfChecksum, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionItemsTable extends InspectionItems
    with TableInfo<$InspectionItemsTable, InspectionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checklistItemIdMeta = const VerificationMeta(
    'checklistItemId',
  );
  @override
  late final GeneratedColumn<String> checklistItemId = GeneratedColumn<String>(
    'checklist_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultStatusMeta = const VerificationMeta(
    'resultStatus',
  );
  @override
  late final GeneratedColumn<String> resultStatus = GeneratedColumn<String>(
    'result_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('not_checked'),
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measuredValueMeta = const VerificationMeta(
    'measuredValue',
  );
  @override
  late final GeneratedColumn<String> measuredValue = GeneratedColumn<String>(
    'measured_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inspectionId,
    checklistItemId,
    componentId,
    resultStatus,
    comment,
    measuredValue,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('checklist_item_id')) {
      context.handle(
        _checklistItemIdMeta,
        checklistItemId.isAcceptableOrUnknown(
          data['checklist_item_id']!,
          _checklistItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checklistItemIdMeta);
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    }
    if (data.containsKey('result_status')) {
      context.handle(
        _resultStatusMeta,
        resultStatus.isAcceptableOrUnknown(
          data['result_status']!,
          _resultStatusMeta,
        ),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('measured_value')) {
      context.handle(
        _measuredValueMeta,
        measuredValue.isAcceptableOrUnknown(
          data['measured_value']!,
          _measuredValueMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspectionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      checklistItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checklist_item_id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      ),
      resultStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_status'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      measuredValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measured_value'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InspectionItemsTable createAlias(String alias) {
    return $InspectionItemsTable(attachedDatabase, alias);
  }
}

class InspectionItem extends DataClass implements Insertable<InspectionItem> {
  final String id;
  final String inspectionId;
  final String checklistItemId;
  final String? componentId;
  final String resultStatus;
  final String? comment;
  final String? measuredValue;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;
  const InspectionItem({
    required this.id,
    required this.inspectionId,
    required this.checklistItemId,
    this.componentId,
    required this.resultStatus,
    this.comment,
    this.measuredValue,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inspection_id'] = Variable<String>(inspectionId);
    map['checklist_item_id'] = Variable<String>(checklistItemId);
    if (!nullToAbsent || componentId != null) {
      map['component_id'] = Variable<String>(componentId);
    }
    map['result_status'] = Variable<String>(resultStatus);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || measuredValue != null) {
      map['measured_value'] = Variable<String>(measuredValue);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  InspectionItemsCompanion toCompanion(bool nullToAbsent) {
    return InspectionItemsCompanion(
      id: Value(id),
      inspectionId: Value(inspectionId),
      checklistItemId: Value(checklistItemId),
      componentId: componentId == null && nullToAbsent
          ? const Value.absent()
          : Value(componentId),
      resultStatus: Value(resultStatus),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      measuredValue: measuredValue == null && nullToAbsent
          ? const Value.absent()
          : Value(measuredValue),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InspectionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionItem(
      id: serializer.fromJson<String>(json['id']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      checklistItemId: serializer.fromJson<String>(json['checklistItemId']),
      componentId: serializer.fromJson<String?>(json['componentId']),
      resultStatus: serializer.fromJson<String>(json['resultStatus']),
      comment: serializer.fromJson<String?>(json['comment']),
      measuredValue: serializer.fromJson<String?>(json['measuredValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'checklistItemId': serializer.toJson<String>(checklistItemId),
      'componentId': serializer.toJson<String?>(componentId),
      'resultStatus': serializer.toJson<String>(resultStatus),
      'comment': serializer.toJson<String?>(comment),
      'measuredValue': serializer.toJson<String?>(measuredValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  InspectionItem copyWith({
    String? id,
    String? inspectionId,
    String? checklistItemId,
    Value<String?> componentId = const Value.absent(),
    String? resultStatus,
    Value<String?> comment = const Value.absent(),
    Value<String?> measuredValue = const Value.absent(),
    int? sortOrder,
    String? createdAt,
    String? updatedAt,
  }) => InspectionItem(
    id: id ?? this.id,
    inspectionId: inspectionId ?? this.inspectionId,
    checklistItemId: checklistItemId ?? this.checklistItemId,
    componentId: componentId.present ? componentId.value : this.componentId,
    resultStatus: resultStatus ?? this.resultStatus,
    comment: comment.present ? comment.value : this.comment,
    measuredValue: measuredValue.present
        ? measuredValue.value
        : this.measuredValue,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InspectionItem copyWithCompanion(InspectionItemsCompanion data) {
    return InspectionItem(
      id: data.id.present ? data.id.value : this.id,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      checklistItemId: data.checklistItemId.present
          ? data.checklistItemId.value
          : this.checklistItemId,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      resultStatus: data.resultStatus.present
          ? data.resultStatus.value
          : this.resultStatus,
      comment: data.comment.present ? data.comment.value : this.comment,
      measuredValue: data.measuredValue.present
          ? data.measuredValue.value
          : this.measuredValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionItem(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('checklistItemId: $checklistItemId, ')
          ..write('componentId: $componentId, ')
          ..write('resultStatus: $resultStatus, ')
          ..write('comment: $comment, ')
          ..write('measuredValue: $measuredValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    inspectionId,
    checklistItemId,
    componentId,
    resultStatus,
    comment,
    measuredValue,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionItem &&
          other.id == this.id &&
          other.inspectionId == this.inspectionId &&
          other.checklistItemId == this.checklistItemId &&
          other.componentId == this.componentId &&
          other.resultStatus == this.resultStatus &&
          other.comment == this.comment &&
          other.measuredValue == this.measuredValue &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InspectionItemsCompanion extends UpdateCompanion<InspectionItem> {
  final Value<String> id;
  final Value<String> inspectionId;
  final Value<String> checklistItemId;
  final Value<String?> componentId;
  final Value<String> resultStatus;
  final Value<String?> comment;
  final Value<String?> measuredValue;
  final Value<int> sortOrder;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const InspectionItemsCompanion({
    this.id = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.checklistItemId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.resultStatus = const Value.absent(),
    this.comment = const Value.absent(),
    this.measuredValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionItemsCompanion.insert({
    required String id,
    required String inspectionId,
    required String checklistItemId,
    this.componentId = const Value.absent(),
    this.resultStatus = const Value.absent(),
    this.comment = const Value.absent(),
    this.measuredValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       inspectionId = Value(inspectionId),
       checklistItemId = Value(checklistItemId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InspectionItem> custom({
    Expression<String>? id,
    Expression<String>? inspectionId,
    Expression<String>? checklistItemId,
    Expression<String>? componentId,
    Expression<String>? resultStatus,
    Expression<String>? comment,
    Expression<String>? measuredValue,
    Expression<int>? sortOrder,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (checklistItemId != null) 'checklist_item_id': checklistItemId,
      if (componentId != null) 'component_id': componentId,
      if (resultStatus != null) 'result_status': resultStatus,
      if (comment != null) 'comment': comment,
      if (measuredValue != null) 'measured_value': measuredValue,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? inspectionId,
    Value<String>? checklistItemId,
    Value<String?>? componentId,
    Value<String>? resultStatus,
    Value<String?>? comment,
    Value<String?>? measuredValue,
    Value<int>? sortOrder,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return InspectionItemsCompanion(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      checklistItemId: checklistItemId ?? this.checklistItemId,
      componentId: componentId ?? this.componentId,
      resultStatus: resultStatus ?? this.resultStatus,
      comment: comment ?? this.comment,
      measuredValue: measuredValue ?? this.measuredValue,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (checklistItemId.present) {
      map['checklist_item_id'] = Variable<String>(checklistItemId.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (resultStatus.present) {
      map['result_status'] = Variable<String>(resultStatus.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (measuredValue.present) {
      map['measured_value'] = Variable<String>(measuredValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionItemsCompanion(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('checklistItemId: $checklistItemId, ')
          ..write('componentId: $componentId, ')
          ..write('resultStatus: $resultStatus, ')
          ..write('comment: $comment, ')
          ..write('measuredValue: $measuredValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionSignaturesTable extends InspectionSignatures
    with TableInfo<$InspectionSignaturesTable, InspectionSignature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionSignaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signerUserIdMeta = const VerificationMeta(
    'signerUserId',
  );
  @override
  late final GeneratedColumn<String> signerUserId = GeneratedColumn<String>(
    'signer_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signerNameMeta = const VerificationMeta(
    'signerName',
  );
  @override
  late final GeneratedColumn<String> signerName = GeneratedColumn<String>(
    'signer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signerRoleMeta = const VerificationMeta(
    'signerRole',
  );
  @override
  late final GeneratedColumn<String> signerRole = GeneratedColumn<String>(
    'signer_role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageLocalPathMeta = const VerificationMeta(
    'imageLocalPath',
  );
  @override
  late final GeneratedColumn<String> imageLocalPath = GeneratedColumn<String>(
    'image_local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checksumMeta = const VerificationMeta(
    'checksum',
  );
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signedAtMeta = const VerificationMeta(
    'signedAt',
  );
  @override
  late final GeneratedColumn<String> signedAt = GeneratedColumn<String>(
    'signed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inspectionId,
    signerUserId,
    signerName,
    signerRole,
    imageLocalPath,
    checksum,
    signedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_signatures';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionSignature> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('signer_user_id')) {
      context.handle(
        _signerUserIdMeta,
        signerUserId.isAcceptableOrUnknown(
          data['signer_user_id']!,
          _signerUserIdMeta,
        ),
      );
    }
    if (data.containsKey('signer_name')) {
      context.handle(
        _signerNameMeta,
        signerName.isAcceptableOrUnknown(data['signer_name']!, _signerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_signerNameMeta);
    }
    if (data.containsKey('signer_role')) {
      context.handle(
        _signerRoleMeta,
        signerRole.isAcceptableOrUnknown(data['signer_role']!, _signerRoleMeta),
      );
    } else if (isInserting) {
      context.missing(_signerRoleMeta);
    }
    if (data.containsKey('image_local_path')) {
      context.handle(
        _imageLocalPathMeta,
        imageLocalPath.isAcceptableOrUnknown(
          data['image_local_path']!,
          _imageLocalPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_imageLocalPathMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _checksumMeta,
        checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta),
      );
    } else if (isInserting) {
      context.missing(_checksumMeta);
    }
    if (data.containsKey('signed_at')) {
      context.handle(
        _signedAtMeta,
        signedAt.isAcceptableOrUnknown(data['signed_at']!, _signedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_signedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspectionSignature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionSignature(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      signerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signer_user_id'],
      ),
      signerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signer_name'],
      )!,
      signerRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signer_role'],
      )!,
      imageLocalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_local_path'],
      )!,
      checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      )!,
      signedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signed_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InspectionSignaturesTable createAlias(String alias) {
    return $InspectionSignaturesTable(attachedDatabase, alias);
  }
}

class InspectionSignature extends DataClass
    implements Insertable<InspectionSignature> {
  final String id;
  final String inspectionId;
  final String? signerUserId;
  final String signerName;
  final String signerRole;
  final String imageLocalPath;
  final String checksum;
  final String signedAt;
  final String createdAt;
  final String updatedAt;
  const InspectionSignature({
    required this.id,
    required this.inspectionId,
    this.signerUserId,
    required this.signerName,
    required this.signerRole,
    required this.imageLocalPath,
    required this.checksum,
    required this.signedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inspection_id'] = Variable<String>(inspectionId);
    if (!nullToAbsent || signerUserId != null) {
      map['signer_user_id'] = Variable<String>(signerUserId);
    }
    map['signer_name'] = Variable<String>(signerName);
    map['signer_role'] = Variable<String>(signerRole);
    map['image_local_path'] = Variable<String>(imageLocalPath);
    map['checksum'] = Variable<String>(checksum);
    map['signed_at'] = Variable<String>(signedAt);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  InspectionSignaturesCompanion toCompanion(bool nullToAbsent) {
    return InspectionSignaturesCompanion(
      id: Value(id),
      inspectionId: Value(inspectionId),
      signerUserId: signerUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(signerUserId),
      signerName: Value(signerName),
      signerRole: Value(signerRole),
      imageLocalPath: Value(imageLocalPath),
      checksum: Value(checksum),
      signedAt: Value(signedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InspectionSignature.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionSignature(
      id: serializer.fromJson<String>(json['id']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      signerUserId: serializer.fromJson<String?>(json['signerUserId']),
      signerName: serializer.fromJson<String>(json['signerName']),
      signerRole: serializer.fromJson<String>(json['signerRole']),
      imageLocalPath: serializer.fromJson<String>(json['imageLocalPath']),
      checksum: serializer.fromJson<String>(json['checksum']),
      signedAt: serializer.fromJson<String>(json['signedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'signerUserId': serializer.toJson<String?>(signerUserId),
      'signerName': serializer.toJson<String>(signerName),
      'signerRole': serializer.toJson<String>(signerRole),
      'imageLocalPath': serializer.toJson<String>(imageLocalPath),
      'checksum': serializer.toJson<String>(checksum),
      'signedAt': serializer.toJson<String>(signedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  InspectionSignature copyWith({
    String? id,
    String? inspectionId,
    Value<String?> signerUserId = const Value.absent(),
    String? signerName,
    String? signerRole,
    String? imageLocalPath,
    String? checksum,
    String? signedAt,
    String? createdAt,
    String? updatedAt,
  }) => InspectionSignature(
    id: id ?? this.id,
    inspectionId: inspectionId ?? this.inspectionId,
    signerUserId: signerUserId.present ? signerUserId.value : this.signerUserId,
    signerName: signerName ?? this.signerName,
    signerRole: signerRole ?? this.signerRole,
    imageLocalPath: imageLocalPath ?? this.imageLocalPath,
    checksum: checksum ?? this.checksum,
    signedAt: signedAt ?? this.signedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InspectionSignature copyWithCompanion(InspectionSignaturesCompanion data) {
    return InspectionSignature(
      id: data.id.present ? data.id.value : this.id,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      signerUserId: data.signerUserId.present
          ? data.signerUserId.value
          : this.signerUserId,
      signerName: data.signerName.present
          ? data.signerName.value
          : this.signerName,
      signerRole: data.signerRole.present
          ? data.signerRole.value
          : this.signerRole,
      imageLocalPath: data.imageLocalPath.present
          ? data.imageLocalPath.value
          : this.imageLocalPath,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      signedAt: data.signedAt.present ? data.signedAt.value : this.signedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionSignature(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('signerUserId: $signerUserId, ')
          ..write('signerName: $signerName, ')
          ..write('signerRole: $signerRole, ')
          ..write('imageLocalPath: $imageLocalPath, ')
          ..write('checksum: $checksum, ')
          ..write('signedAt: $signedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    inspectionId,
    signerUserId,
    signerName,
    signerRole,
    imageLocalPath,
    checksum,
    signedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionSignature &&
          other.id == this.id &&
          other.inspectionId == this.inspectionId &&
          other.signerUserId == this.signerUserId &&
          other.signerName == this.signerName &&
          other.signerRole == this.signerRole &&
          other.imageLocalPath == this.imageLocalPath &&
          other.checksum == this.checksum &&
          other.signedAt == this.signedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InspectionSignaturesCompanion
    extends UpdateCompanion<InspectionSignature> {
  final Value<String> id;
  final Value<String> inspectionId;
  final Value<String?> signerUserId;
  final Value<String> signerName;
  final Value<String> signerRole;
  final Value<String> imageLocalPath;
  final Value<String> checksum;
  final Value<String> signedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const InspectionSignaturesCompanion({
    this.id = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.signerUserId = const Value.absent(),
    this.signerName = const Value.absent(),
    this.signerRole = const Value.absent(),
    this.imageLocalPath = const Value.absent(),
    this.checksum = const Value.absent(),
    this.signedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionSignaturesCompanion.insert({
    required String id,
    required String inspectionId,
    this.signerUserId = const Value.absent(),
    required String signerName,
    required String signerRole,
    required String imageLocalPath,
    required String checksum,
    required String signedAt,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       inspectionId = Value(inspectionId),
       signerName = Value(signerName),
       signerRole = Value(signerRole),
       imageLocalPath = Value(imageLocalPath),
       checksum = Value(checksum),
       signedAt = Value(signedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InspectionSignature> custom({
    Expression<String>? id,
    Expression<String>? inspectionId,
    Expression<String>? signerUserId,
    Expression<String>? signerName,
    Expression<String>? signerRole,
    Expression<String>? imageLocalPath,
    Expression<String>? checksum,
    Expression<String>? signedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (signerUserId != null) 'signer_user_id': signerUserId,
      if (signerName != null) 'signer_name': signerName,
      if (signerRole != null) 'signer_role': signerRole,
      if (imageLocalPath != null) 'image_local_path': imageLocalPath,
      if (checksum != null) 'checksum': checksum,
      if (signedAt != null) 'signed_at': signedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionSignaturesCompanion copyWith({
    Value<String>? id,
    Value<String>? inspectionId,
    Value<String?>? signerUserId,
    Value<String>? signerName,
    Value<String>? signerRole,
    Value<String>? imageLocalPath,
    Value<String>? checksum,
    Value<String>? signedAt,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return InspectionSignaturesCompanion(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      signerUserId: signerUserId ?? this.signerUserId,
      signerName: signerName ?? this.signerName,
      signerRole: signerRole ?? this.signerRole,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      checksum: checksum ?? this.checksum,
      signedAt: signedAt ?? this.signedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (signerUserId.present) {
      map['signer_user_id'] = Variable<String>(signerUserId.value);
    }
    if (signerName.present) {
      map['signer_name'] = Variable<String>(signerName.value);
    }
    if (signerRole.present) {
      map['signer_role'] = Variable<String>(signerRole.value);
    }
    if (imageLocalPath.present) {
      map['image_local_path'] = Variable<String>(imageLocalPath.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (signedAt.present) {
      map['signed_at'] = Variable<String>(signedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionSignaturesCompanion(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('signerUserId: $signerUserId, ')
          ..write('signerName: $signerName, ')
          ..write('signerRole: $signerRole, ')
          ..write('imageLocalPath: $imageLocalPath, ')
          ..write('checksum: $checksum, ')
          ..write('signedAt: $signedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionFilesTable extends InspectionFiles
    with TableInfo<$InspectionFilesTable, InspectionFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checksumMeta = const VerificationMeta(
    'checksum',
  );
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inspectionId,
    fileType,
    fileName,
    localPath,
    checksum,
    mimeType,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _checksumMeta,
        checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta),
      );
    } else if (isInserting) {
      context.missing(_checksumMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspectionFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InspectionFilesTable createAlias(String alias) {
    return $InspectionFilesTable(attachedDatabase, alias);
  }
}

class InspectionFile extends DataClass implements Insertable<InspectionFile> {
  final String id;
  final String inspectionId;
  final String fileType;
  final String fileName;
  final String localPath;
  final String checksum;
  final String mimeType;
  final String createdAt;
  final String updatedAt;
  const InspectionFile({
    required this.id,
    required this.inspectionId,
    required this.fileType,
    required this.fileName,
    required this.localPath,
    required this.checksum,
    required this.mimeType,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inspection_id'] = Variable<String>(inspectionId);
    map['file_type'] = Variable<String>(fileType);
    map['file_name'] = Variable<String>(fileName);
    map['local_path'] = Variable<String>(localPath);
    map['checksum'] = Variable<String>(checksum);
    map['mime_type'] = Variable<String>(mimeType);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  InspectionFilesCompanion toCompanion(bool nullToAbsent) {
    return InspectionFilesCompanion(
      id: Value(id),
      inspectionId: Value(inspectionId),
      fileType: Value(fileType),
      fileName: Value(fileName),
      localPath: Value(localPath),
      checksum: Value(checksum),
      mimeType: Value(mimeType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InspectionFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionFile(
      id: serializer.fromJson<String>(json['id']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      fileType: serializer.fromJson<String>(json['fileType']),
      fileName: serializer.fromJson<String>(json['fileName']),
      localPath: serializer.fromJson<String>(json['localPath']),
      checksum: serializer.fromJson<String>(json['checksum']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'fileType': serializer.toJson<String>(fileType),
      'fileName': serializer.toJson<String>(fileName),
      'localPath': serializer.toJson<String>(localPath),
      'checksum': serializer.toJson<String>(checksum),
      'mimeType': serializer.toJson<String>(mimeType),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  InspectionFile copyWith({
    String? id,
    String? inspectionId,
    String? fileType,
    String? fileName,
    String? localPath,
    String? checksum,
    String? mimeType,
    String? createdAt,
    String? updatedAt,
  }) => InspectionFile(
    id: id ?? this.id,
    inspectionId: inspectionId ?? this.inspectionId,
    fileType: fileType ?? this.fileType,
    fileName: fileName ?? this.fileName,
    localPath: localPath ?? this.localPath,
    checksum: checksum ?? this.checksum,
    mimeType: mimeType ?? this.mimeType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InspectionFile copyWithCompanion(InspectionFilesCompanion data) {
    return InspectionFile(
      id: data.id.present ? data.id.value : this.id,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionFile(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('fileType: $fileType, ')
          ..write('fileName: $fileName, ')
          ..write('localPath: $localPath, ')
          ..write('checksum: $checksum, ')
          ..write('mimeType: $mimeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    inspectionId,
    fileType,
    fileName,
    localPath,
    checksum,
    mimeType,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionFile &&
          other.id == this.id &&
          other.inspectionId == this.inspectionId &&
          other.fileType == this.fileType &&
          other.fileName == this.fileName &&
          other.localPath == this.localPath &&
          other.checksum == this.checksum &&
          other.mimeType == this.mimeType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InspectionFilesCompanion extends UpdateCompanion<InspectionFile> {
  final Value<String> id;
  final Value<String> inspectionId;
  final Value<String> fileType;
  final Value<String> fileName;
  final Value<String> localPath;
  final Value<String> checksum;
  final Value<String> mimeType;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const InspectionFilesCompanion({
    this.id = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.fileType = const Value.absent(),
    this.fileName = const Value.absent(),
    this.localPath = const Value.absent(),
    this.checksum = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionFilesCompanion.insert({
    required String id,
    required String inspectionId,
    required String fileType,
    required String fileName,
    required String localPath,
    required String checksum,
    required String mimeType,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       inspectionId = Value(inspectionId),
       fileType = Value(fileType),
       fileName = Value(fileName),
       localPath = Value(localPath),
       checksum = Value(checksum),
       mimeType = Value(mimeType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InspectionFile> custom({
    Expression<String>? id,
    Expression<String>? inspectionId,
    Expression<String>? fileType,
    Expression<String>? fileName,
    Expression<String>? localPath,
    Expression<String>? checksum,
    Expression<String>? mimeType,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (fileType != null) 'file_type': fileType,
      if (fileName != null) 'file_name': fileName,
      if (localPath != null) 'local_path': localPath,
      if (checksum != null) 'checksum': checksum,
      if (mimeType != null) 'mime_type': mimeType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionFilesCompanion copyWith({
    Value<String>? id,
    Value<String>? inspectionId,
    Value<String>? fileType,
    Value<String>? fileName,
    Value<String>? localPath,
    Value<String>? checksum,
    Value<String>? mimeType,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return InspectionFilesCompanion(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      fileType: fileType ?? this.fileType,
      fileName: fileName ?? this.fileName,
      localPath: localPath ?? this.localPath,
      checksum: checksum ?? this.checksum,
      mimeType: mimeType ?? this.mimeType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionFilesCompanion(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('fileType: $fileType, ')
          ..write('fileName: $fileName, ')
          ..write('localPath: $localPath, ')
          ..write('checksum: $checksum, ')
          ..write('mimeType: $mimeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrashBinTable extends TrashBin
    with TableInfo<$TrashBinTable, TrashBinData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrashBinTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snapshotJsonMeta = const VerificationMeta(
    'snapshotJson',
  );
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
    'snapshot_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedByUserIdMeta = const VerificationMeta(
    'deletedByUserId',
  );
  @override
  late final GeneratedColumn<String> deletedByUserId = GeneratedColumn<String>(
    'deleted_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restoredAtMeta = const VerificationMeta(
    'restoredAt',
  );
  @override
  late final GeneratedColumn<String> restoredAt = GeneratedColumn<String>(
    'restored_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permanentlyDeletedAtMeta =
      const VerificationMeta('permanentlyDeletedAt');
  @override
  late final GeneratedColumn<String> permanentlyDeletedAt =
      GeneratedColumn<String>(
        'permanently_deleted_at',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    displayName,
    snapshotJson,
    deletedByUserId,
    deletedAt,
    restoredAt,
    permanentlyDeletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trash_bin';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrashBinData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
        _snapshotJsonMeta,
        snapshotJson.isAcceptableOrUnknown(
          data['snapshot_json']!,
          _snapshotJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotJsonMeta);
    }
    if (data.containsKey('deleted_by_user_id')) {
      context.handle(
        _deletedByUserIdMeta,
        deletedByUserId.isAcceptableOrUnknown(
          data['deleted_by_user_id']!,
          _deletedByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedAtMeta);
    }
    if (data.containsKey('restored_at')) {
      context.handle(
        _restoredAtMeta,
        restoredAt.isAcceptableOrUnknown(data['restored_at']!, _restoredAtMeta),
      );
    }
    if (data.containsKey('permanently_deleted_at')) {
      context.handle(
        _permanentlyDeletedAtMeta,
        permanentlyDeletedAt.isAcceptableOrUnknown(
          data['permanently_deleted_at']!,
          _permanentlyDeletedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrashBinData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrashBinData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      snapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_json'],
      )!,
      deletedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_by_user_id'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      )!,
      restoredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}restored_at'],
      ),
      permanentlyDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permanently_deleted_at'],
      ),
    );
  }

  @override
  $TrashBinTable createAlias(String alias) {
    return $TrashBinTable(attachedDatabase, alias);
  }
}

class TrashBinData extends DataClass implements Insertable<TrashBinData> {
  final String id;
  final String entityType;
  final String entityId;
  final String displayName;
  final String snapshotJson;
  final String? deletedByUserId;
  final String deletedAt;
  final String? restoredAt;
  final String? permanentlyDeletedAt;
  const TrashBinData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.displayName,
    required this.snapshotJson,
    this.deletedByUserId,
    required this.deletedAt,
    this.restoredAt,
    this.permanentlyDeletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['display_name'] = Variable<String>(displayName);
    map['snapshot_json'] = Variable<String>(snapshotJson);
    if (!nullToAbsent || deletedByUserId != null) {
      map['deleted_by_user_id'] = Variable<String>(deletedByUserId);
    }
    map['deleted_at'] = Variable<String>(deletedAt);
    if (!nullToAbsent || restoredAt != null) {
      map['restored_at'] = Variable<String>(restoredAt);
    }
    if (!nullToAbsent || permanentlyDeletedAt != null) {
      map['permanently_deleted_at'] = Variable<String>(permanentlyDeletedAt);
    }
    return map;
  }

  TrashBinCompanion toCompanion(bool nullToAbsent) {
    return TrashBinCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      displayName: Value(displayName),
      snapshotJson: Value(snapshotJson),
      deletedByUserId: deletedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedByUserId),
      deletedAt: Value(deletedAt),
      restoredAt: restoredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(restoredAt),
      permanentlyDeletedAt: permanentlyDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(permanentlyDeletedAt),
    );
  }

  factory TrashBinData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrashBinData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      snapshotJson: serializer.fromJson<String>(json['snapshotJson']),
      deletedByUserId: serializer.fromJson<String?>(json['deletedByUserId']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
      restoredAt: serializer.fromJson<String?>(json['restoredAt']),
      permanentlyDeletedAt: serializer.fromJson<String?>(
        json['permanentlyDeletedAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'displayName': serializer.toJson<String>(displayName),
      'snapshotJson': serializer.toJson<String>(snapshotJson),
      'deletedByUserId': serializer.toJson<String?>(deletedByUserId),
      'deletedAt': serializer.toJson<String>(deletedAt),
      'restoredAt': serializer.toJson<String?>(restoredAt),
      'permanentlyDeletedAt': serializer.toJson<String?>(permanentlyDeletedAt),
    };
  }

  TrashBinData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? displayName,
    String? snapshotJson,
    Value<String?> deletedByUserId = const Value.absent(),
    String? deletedAt,
    Value<String?> restoredAt = const Value.absent(),
    Value<String?> permanentlyDeletedAt = const Value.absent(),
  }) => TrashBinData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    displayName: displayName ?? this.displayName,
    snapshotJson: snapshotJson ?? this.snapshotJson,
    deletedByUserId: deletedByUserId.present
        ? deletedByUserId.value
        : this.deletedByUserId,
    deletedAt: deletedAt ?? this.deletedAt,
    restoredAt: restoredAt.present ? restoredAt.value : this.restoredAt,
    permanentlyDeletedAt: permanentlyDeletedAt.present
        ? permanentlyDeletedAt.value
        : this.permanentlyDeletedAt,
  );
  TrashBinData copyWithCompanion(TrashBinCompanion data) {
    return TrashBinData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
      deletedByUserId: data.deletedByUserId.present
          ? data.deletedByUserId.value
          : this.deletedByUserId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      restoredAt: data.restoredAt.present
          ? data.restoredAt.value
          : this.restoredAt,
      permanentlyDeletedAt: data.permanentlyDeletedAt.present
          ? data.permanentlyDeletedAt.value
          : this.permanentlyDeletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrashBinData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('displayName: $displayName, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('deletedByUserId: $deletedByUserId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('restoredAt: $restoredAt, ')
          ..write('permanentlyDeletedAt: $permanentlyDeletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    displayName,
    snapshotJson,
    deletedByUserId,
    deletedAt,
    restoredAt,
    permanentlyDeletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrashBinData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.displayName == this.displayName &&
          other.snapshotJson == this.snapshotJson &&
          other.deletedByUserId == this.deletedByUserId &&
          other.deletedAt == this.deletedAt &&
          other.restoredAt == this.restoredAt &&
          other.permanentlyDeletedAt == this.permanentlyDeletedAt);
}

class TrashBinCompanion extends UpdateCompanion<TrashBinData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> displayName;
  final Value<String> snapshotJson;
  final Value<String?> deletedByUserId;
  final Value<String> deletedAt;
  final Value<String?> restoredAt;
  final Value<String?> permanentlyDeletedAt;
  final Value<int> rowid;
  const TrashBinCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.deletedByUserId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.restoredAt = const Value.absent(),
    this.permanentlyDeletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrashBinCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String displayName,
    required String snapshotJson,
    this.deletedByUserId = const Value.absent(),
    required String deletedAt,
    this.restoredAt = const Value.absent(),
    this.permanentlyDeletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       displayName = Value(displayName),
       snapshotJson = Value(snapshotJson),
       deletedAt = Value(deletedAt);
  static Insertable<TrashBinData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? displayName,
    Expression<String>? snapshotJson,
    Expression<String>? deletedByUserId,
    Expression<String>? deletedAt,
    Expression<String>? restoredAt,
    Expression<String>? permanentlyDeletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (displayName != null) 'display_name': displayName,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (deletedByUserId != null) 'deleted_by_user_id': deletedByUserId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (restoredAt != null) 'restored_at': restoredAt,
      if (permanentlyDeletedAt != null)
        'permanently_deleted_at': permanentlyDeletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrashBinCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? displayName,
    Value<String>? snapshotJson,
    Value<String?>? deletedByUserId,
    Value<String>? deletedAt,
    Value<String?>? restoredAt,
    Value<String?>? permanentlyDeletedAt,
    Value<int>? rowid,
  }) {
    return TrashBinCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      displayName: displayName ?? this.displayName,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      deletedByUserId: deletedByUserId ?? this.deletedByUserId,
      deletedAt: deletedAt ?? this.deletedAt,
      restoredAt: restoredAt ?? this.restoredAt,
      permanentlyDeletedAt: permanentlyDeletedAt ?? this.permanentlyDeletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (deletedByUserId.present) {
      map['deleted_by_user_id'] = Variable<String>(deletedByUserId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (restoredAt.present) {
      map['restored_at'] = Variable<String>(restoredAt.value);
    }
    if (permanentlyDeletedAt.present) {
      map['permanently_deleted_at'] = Variable<String>(
        permanentlyDeletedAt.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrashBinCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('displayName: $displayName, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('deletedByUserId: $deletedByUserId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('restoredAt: $restoredAt, ')
          ..write('permanentlyDeletedAt: $permanentlyDeletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RolesTable roles = $RolesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $DeviceInfoTable deviceInfo = $DeviceInfoTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $DepartmentsTable departments = $DepartmentsTable(this);
  late final $WorkshopsTable workshops = $WorkshopsTable(this);
  late final $SectionsTable sections = $SectionsTable(this);
  late final $CatalogObjectsTable catalogObjects = $CatalogObjectsTable(this);
  late final $ObjectRelationsTable objectRelations = $ObjectRelationsTable(
    this,
  );
  late final $ComponentsTable components = $ComponentsTable(this);
  late final $ChecklistsTable checklists = $ChecklistsTable(this);
  late final $ChecklistItemsTable checklistItems = $ChecklistItemsTable(this);
  late final $ChecklistBindingsTable checklistBindings =
      $ChecklistBindingsTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $LocksTable locks = $LocksTable(this);
  late final $ComponentImagesTable componentImages = $ComponentImagesTable(
    this,
  );
  late final $InspectionsTable inspections = $InspectionsTable(this);
  late final $InspectionItemsTable inspectionItems = $InspectionItemsTable(
    this,
  );
  late final $InspectionSignaturesTable inspectionSignatures =
      $InspectionSignaturesTable(this);
  late final $InspectionFilesTable inspectionFiles = $InspectionFilesTable(
    this,
  );
  late final $TrashBinTable trashBin = $TrashBinTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    roles,
    appSettings,
    auditLog,
    deviceInfo,
    users,
    departments,
    workshops,
    sections,
    catalogObjects,
    objectRelations,
    components,
    checklists,
    checklistItems,
    checklistBindings,
    syncState,
    syncQueue,
    locks,
    componentImages,
    inspections,
    inspectionItems,
    inspectionSignatures,
    inspectionFiles,
    trashBin,
  ];
}

typedef $$RolesTableCreateCompanionBuilder =
    RolesCompanion Function({
      required String id,
      required String code,
      required String name,
      Value<String?> description,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$RolesTableUpdateCompanionBuilder =
    RolesCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<String?> description,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$RolesTableFilterComposer extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RolesTableOrderingComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RolesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RolesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RolesTable,
          Role,
          $$RolesTableFilterComposer,
          $$RolesTableOrderingComposer,
          $$RolesTableAnnotationComposer,
          $$RolesTableCreateCompanionBuilder,
          $$RolesTableUpdateCompanionBuilder,
          (Role, BaseReferences<_$AppDatabase, $RolesTable, Role>),
          Role,
          PrefetchHooks Function()
        > {
  $$RolesTableTableManager(_$AppDatabase db, $RolesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RolesCompanion(
                id: id,
                code: code,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                Value<String?> description = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RolesCompanion.insert(
                id: id,
                code: code,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RolesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RolesTable,
      Role,
      $$RolesTableFilterComposer,
      $$RolesTableOrderingComposer,
      $$RolesTableAnnotationComposer,
      $$RolesTableCreateCompanionBuilder,
      $$RolesTableUpdateCompanionBuilder,
      (Role, BaseReferences<_$AppDatabase, $RolesTable, Role>),
      Role,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String valueJson,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> valueJson,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> valueJson = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                valueJson: valueJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String valueJson,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                valueJson: valueJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$AuditLogTableCreateCompanionBuilder =
    AuditLogCompanion Function({
      required String id,
      required String happenedAt,
      Value<String?> userId,
      Value<String?> deviceId,
      required String actionType,
      Value<String?> entityType,
      Value<String?> entityId,
      required String resultStatus,
      Value<String?> message,
      Value<String?> payloadJson,
      Value<int> rowid,
    });
typedef $$AuditLogTableUpdateCompanionBuilder =
    AuditLogCompanion Function({
      Value<String> id,
      Value<String> happenedAt,
      Value<String?> userId,
      Value<String?> deviceId,
      Value<String> actionType,
      Value<String?> entityType,
      Value<String?> entityId,
      Value<String> resultStatus,
      Value<String?> message,
      Value<String?> payloadJson,
      Value<int> rowid,
    });

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get happenedAt => $composableBuilder(
    column: $table.happenedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultStatus => $composableBuilder(
    column: $table.resultStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get happenedAt => $composableBuilder(
    column: $table.happenedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultStatus => $composableBuilder(
    column: $table.resultStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get happenedAt => $composableBuilder(
    column: $table.happenedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get resultStatus => $composableBuilder(
    column: $table.resultStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditLogData,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditLogData,
            BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
          ),
          AuditLogData,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> happenedAt = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<String> resultStatus = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<String?> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                happenedAt: happenedAt,
                userId: userId,
                deviceId: deviceId,
                actionType: actionType,
                entityType: entityType,
                entityId: entityId,
                resultStatus: resultStatus,
                message: message,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String happenedAt,
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String actionType,
                Value<String?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                required String resultStatus,
                Value<String?> message = const Value.absent(),
                Value<String?> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                happenedAt: happenedAt,
                userId: userId,
                deviceId: deviceId,
                actionType: actionType,
                entityType: entityType,
                entityId: entityId,
                resultStatus: resultStatus,
                message: message,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditLogData,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (
        AuditLogData,
        BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
      ),
      AuditLogData,
      PrefetchHooks Function()
    >;
typedef $$DeviceInfoTableCreateCompanionBuilder =
    DeviceInfoCompanion Function({
      required String id,
      required String deviceName,
      required String platform,
      required String appVersion,
      required String dbSchemaVersion,
      required String syncSchemaVersion,
      required String rootPath,
      Value<String?> lastSyncAt,
      Value<bool> yandexDiskConnected,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$DeviceInfoTableUpdateCompanionBuilder =
    DeviceInfoCompanion Function({
      Value<String> id,
      Value<String> deviceName,
      Value<String> platform,
      Value<String> appVersion,
      Value<String> dbSchemaVersion,
      Value<String> syncSchemaVersion,
      Value<String> rootPath,
      Value<String?> lastSyncAt,
      Value<bool> yandexDiskConnected,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$DeviceInfoTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceInfoTable> {
  $$DeviceInfoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dbSchemaVersion => $composableBuilder(
    column: $table.dbSchemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncSchemaVersion => $composableBuilder(
    column: $table.syncSchemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootPath => $composableBuilder(
    column: $table.rootPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get yandexDiskConnected => $composableBuilder(
    column: $table.yandexDiskConnected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceInfoTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceInfoTable> {
  $$DeviceInfoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dbSchemaVersion => $composableBuilder(
    column: $table.dbSchemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncSchemaVersion => $composableBuilder(
    column: $table.syncSchemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootPath => $composableBuilder(
    column: $table.rootPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get yandexDiskConnected => $composableBuilder(
    column: $table.yandexDiskConnected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceInfoTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceInfoTable> {
  $$DeviceInfoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dbSchemaVersion => $composableBuilder(
    column: $table.dbSchemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncSchemaVersion => $composableBuilder(
    column: $table.syncSchemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rootPath =>
      $composableBuilder(column: $table.rootPath, builder: (column) => column);

  GeneratedColumn<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get yandexDiskConnected => $composableBuilder(
    column: $table.yandexDiskConnected,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DeviceInfoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceInfoTable,
          DeviceInfoData,
          $$DeviceInfoTableFilterComposer,
          $$DeviceInfoTableOrderingComposer,
          $$DeviceInfoTableAnnotationComposer,
          $$DeviceInfoTableCreateCompanionBuilder,
          $$DeviceInfoTableUpdateCompanionBuilder,
          (
            DeviceInfoData,
            BaseReferences<_$AppDatabase, $DeviceInfoTable, DeviceInfoData>,
          ),
          DeviceInfoData,
          PrefetchHooks Function()
        > {
  $$DeviceInfoTableTableManager(_$AppDatabase db, $DeviceInfoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceInfoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceInfoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceInfoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deviceName = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
                Value<String> dbSchemaVersion = const Value.absent(),
                Value<String> syncSchemaVersion = const Value.absent(),
                Value<String> rootPath = const Value.absent(),
                Value<String?> lastSyncAt = const Value.absent(),
                Value<bool> yandexDiskConnected = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceInfoCompanion(
                id: id,
                deviceName: deviceName,
                platform: platform,
                appVersion: appVersion,
                dbSchemaVersion: dbSchemaVersion,
                syncSchemaVersion: syncSchemaVersion,
                rootPath: rootPath,
                lastSyncAt: lastSyncAt,
                yandexDiskConnected: yandexDiskConnected,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deviceName,
                required String platform,
                required String appVersion,
                required String dbSchemaVersion,
                required String syncSchemaVersion,
                required String rootPath,
                Value<String?> lastSyncAt = const Value.absent(),
                Value<bool> yandexDiskConnected = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DeviceInfoCompanion.insert(
                id: id,
                deviceName: deviceName,
                platform: platform,
                appVersion: appVersion,
                dbSchemaVersion: dbSchemaVersion,
                syncSchemaVersion: syncSchemaVersion,
                rootPath: rootPath,
                lastSyncAt: lastSyncAt,
                yandexDiskConnected: yandexDiskConnected,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceInfoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceInfoTable,
      DeviceInfoData,
      $$DeviceInfoTableFilterComposer,
      $$DeviceInfoTableOrderingComposer,
      $$DeviceInfoTableAnnotationComposer,
      $$DeviceInfoTableCreateCompanionBuilder,
      $$DeviceInfoTableUpdateCompanionBuilder,
      (
        DeviceInfoData,
        BaseReferences<_$AppDatabase, $DeviceInfoTable, DeviceInfoData>,
      ),
      DeviceInfoData,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String fullName,
      Value<String?> shortName,
      required String roleId,
      Value<String?> pinHash,
      Value<bool> isActive,
      Value<String?> lastLoginAt,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> fullName,
      Value<String?> shortName,
      Value<String> roleId,
      Value<String?> pinHash,
      Value<bool> isActive,
      Value<String?> lastLoginAt,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleId => $composableBuilder(
    column: $table.roleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleId => $composableBuilder(
    column: $table.roleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get shortName =>
      $composableBuilder(column: $table.shortName, builder: (column) => column);

  GeneratedColumn<String> get roleId =>
      $composableBuilder(column: $table.roleId, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> shortName = const Value.absent(),
                Value<String> roleId = const Value.absent(),
                Value<String?> pinHash = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> lastLoginAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                fullName: fullName,
                shortName: shortName,
                roleId: roleId,
                pinHash: pinHash,
                isActive: isActive,
                lastLoginAt: lastLoginAt,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fullName,
                Value<String?> shortName = const Value.absent(),
                required String roleId,
                Value<String?> pinHash = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> lastLoginAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                fullName: fullName,
                shortName: shortName,
                roleId: roleId,
                pinHash: pinHash,
                isActive: isActive,
                lastLoginAt: lastLoginAt,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$DepartmentsTableCreateCompanionBuilder =
    DepartmentsCompanion Function({
      required String id,
      required String name,
      Value<String?> code,
      Value<int> sortOrder,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$DepartmentsTableUpdateCompanionBuilder =
    DepartmentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> code,
      Value<int> sortOrder,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$DepartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DepartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DepartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$DepartmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepartmentsTable,
          Department,
          $$DepartmentsTableFilterComposer,
          $$DepartmentsTableOrderingComposer,
          $$DepartmentsTableAnnotationComposer,
          $$DepartmentsTableCreateCompanionBuilder,
          $$DepartmentsTableUpdateCompanionBuilder,
          (
            Department,
            BaseReferences<_$AppDatabase, $DepartmentsTable, Department>,
          ),
          Department,
          PrefetchHooks Function()
        > {
  $$DepartmentsTableTableManager(_$AppDatabase db, $DepartmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartmentsCompanion(
                id: id,
                name: name,
                code: code,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> code = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartmentsCompanion.insert(
                id: id,
                name: name,
                code: code,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DepartmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepartmentsTable,
      Department,
      $$DepartmentsTableFilterComposer,
      $$DepartmentsTableOrderingComposer,
      $$DepartmentsTableAnnotationComposer,
      $$DepartmentsTableCreateCompanionBuilder,
      $$DepartmentsTableUpdateCompanionBuilder,
      (
        Department,
        BaseReferences<_$AppDatabase, $DepartmentsTable, Department>,
      ),
      Department,
      PrefetchHooks Function()
    >;
typedef $$WorkshopsTableCreateCompanionBuilder =
    WorkshopsCompanion Function({
      required String id,
      required String departmentId,
      required String name,
      Value<String?> code,
      Value<int> sortOrder,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$WorkshopsTableUpdateCompanionBuilder =
    WorkshopsCompanion Function({
      Value<String> id,
      Value<String> departmentId,
      Value<String> name,
      Value<String?> code,
      Value<int> sortOrder,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$WorkshopsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkshopsTable> {
  $$WorkshopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkshopsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkshopsTable> {
  $$WorkshopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkshopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkshopsTable> {
  $$WorkshopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$WorkshopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkshopsTable,
          Workshop,
          $$WorkshopsTableFilterComposer,
          $$WorkshopsTableOrderingComposer,
          $$WorkshopsTableAnnotationComposer,
          $$WorkshopsTableCreateCompanionBuilder,
          $$WorkshopsTableUpdateCompanionBuilder,
          (Workshop, BaseReferences<_$AppDatabase, $WorkshopsTable, Workshop>),
          Workshop,
          PrefetchHooks Function()
        > {
  $$WorkshopsTableTableManager(_$AppDatabase db, $WorkshopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkshopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkshopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkshopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkshopsCompanion(
                id: id,
                departmentId: departmentId,
                name: name,
                code: code,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String departmentId,
                required String name,
                Value<String?> code = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkshopsCompanion.insert(
                id: id,
                departmentId: departmentId,
                name: name,
                code: code,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkshopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkshopsTable,
      Workshop,
      $$WorkshopsTableFilterComposer,
      $$WorkshopsTableOrderingComposer,
      $$WorkshopsTableAnnotationComposer,
      $$WorkshopsTableCreateCompanionBuilder,
      $$WorkshopsTableUpdateCompanionBuilder,
      (Workshop, BaseReferences<_$AppDatabase, $WorkshopsTable, Workshop>),
      Workshop,
      PrefetchHooks Function()
    >;
typedef $$SectionsTableCreateCompanionBuilder =
    SectionsCompanion Function({
      required String id,
      required String workshopId,
      required String name,
      Value<String?> code,
      Value<int> sortOrder,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$SectionsTableUpdateCompanionBuilder =
    SectionsCompanion Function({
      Value<String> id,
      Value<String> workshopId,
      Value<String> name,
      Value<String?> code,
      Value<int> sortOrder,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$SectionsTableFilterComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workshopId => $composableBuilder(
    column: $table.workshopId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workshopId => $composableBuilder(
    column: $table.workshopId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workshopId => $composableBuilder(
    column: $table.workshopId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$SectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SectionsTable,
          Section,
          $$SectionsTableFilterComposer,
          $$SectionsTableOrderingComposer,
          $$SectionsTableAnnotationComposer,
          $$SectionsTableCreateCompanionBuilder,
          $$SectionsTableUpdateCompanionBuilder,
          (Section, BaseReferences<_$AppDatabase, $SectionsTable, Section>),
          Section,
          PrefetchHooks Function()
        > {
  $$SectionsTableTableManager(_$AppDatabase db, $SectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workshopId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionsCompanion(
                id: id,
                workshopId: workshopId,
                name: name,
                code: code,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workshopId,
                required String name,
                Value<String?> code = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionsCompanion.insert(
                id: id,
                workshopId: workshopId,
                name: name,
                code: code,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SectionsTable,
      Section,
      $$SectionsTableFilterComposer,
      $$SectionsTableOrderingComposer,
      $$SectionsTableAnnotationComposer,
      $$SectionsTableCreateCompanionBuilder,
      $$SectionsTableUpdateCompanionBuilder,
      (Section, BaseReferences<_$AppDatabase, $SectionsTable, Section>),
      Section,
      PrefetchHooks Function()
    >;
typedef $$CatalogObjectsTableCreateCompanionBuilder =
    CatalogObjectsCompanion Function({
      required String id,
      required String type,
      Value<String?> sectionId,
      Value<String?> parentId,
      required String name,
      Value<String?> code,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$CatalogObjectsTableUpdateCompanionBuilder =
    CatalogObjectsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String?> sectionId,
      Value<String?> parentId,
      Value<String> name,
      Value<String?> code,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$CatalogObjectsTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogObjectsTable> {
  $$CatalogObjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogObjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogObjectsTable> {
  $$CatalogObjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogObjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogObjectsTable> {
  $$CatalogObjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$CatalogObjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogObjectsTable,
          CatalogObject,
          $$CatalogObjectsTableFilterComposer,
          $$CatalogObjectsTableOrderingComposer,
          $$CatalogObjectsTableAnnotationComposer,
          $$CatalogObjectsTableCreateCompanionBuilder,
          $$CatalogObjectsTableUpdateCompanionBuilder,
          (
            CatalogObject,
            BaseReferences<_$AppDatabase, $CatalogObjectsTable, CatalogObject>,
          ),
          CatalogObject,
          PrefetchHooks Function()
        > {
  $$CatalogObjectsTableTableManager(
    _$AppDatabase db,
    $CatalogObjectsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogObjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogObjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogObjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> sectionId = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogObjectsCompanion(
                id: id,
                type: type,
                sectionId: sectionId,
                parentId: parentId,
                name: name,
                code: code,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                Value<String?> sectionId = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                required String name,
                Value<String?> code = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogObjectsCompanion.insert(
                id: id,
                type: type,
                sectionId: sectionId,
                parentId: parentId,
                name: name,
                code: code,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogObjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogObjectsTable,
      CatalogObject,
      $$CatalogObjectsTableFilterComposer,
      $$CatalogObjectsTableOrderingComposer,
      $$CatalogObjectsTableAnnotationComposer,
      $$CatalogObjectsTableCreateCompanionBuilder,
      $$CatalogObjectsTableUpdateCompanionBuilder,
      (
        CatalogObject,
        BaseReferences<_$AppDatabase, $CatalogObjectsTable, CatalogObject>,
      ),
      CatalogObject,
      PrefetchHooks Function()
    >;
typedef $$ObjectRelationsTableCreateCompanionBuilder =
    ObjectRelationsCompanion Function({
      required String id,
      required String parentObjectId,
      required String childObjectId,
      Value<String> relationType,
      Value<int> sortOrder,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$ObjectRelationsTableUpdateCompanionBuilder =
    ObjectRelationsCompanion Function({
      Value<String> id,
      Value<String> parentObjectId,
      Value<String> childObjectId,
      Value<String> relationType,
      Value<int> sortOrder,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$ObjectRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $ObjectRelationsTable> {
  $$ObjectRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentObjectId => $composableBuilder(
    column: $table.parentObjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get childObjectId => $composableBuilder(
    column: $table.childObjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ObjectRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ObjectRelationsTable> {
  $$ObjectRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentObjectId => $composableBuilder(
    column: $table.parentObjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get childObjectId => $composableBuilder(
    column: $table.childObjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ObjectRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ObjectRelationsTable> {
  $$ObjectRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get parentObjectId => $composableBuilder(
    column: $table.parentObjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get childObjectId => $composableBuilder(
    column: $table.childObjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ObjectRelationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ObjectRelationsTable,
          ObjectRelation,
          $$ObjectRelationsTableFilterComposer,
          $$ObjectRelationsTableOrderingComposer,
          $$ObjectRelationsTableAnnotationComposer,
          $$ObjectRelationsTableCreateCompanionBuilder,
          $$ObjectRelationsTableUpdateCompanionBuilder,
          (
            ObjectRelation,
            BaseReferences<
              _$AppDatabase,
              $ObjectRelationsTable,
              ObjectRelation
            >,
          ),
          ObjectRelation,
          PrefetchHooks Function()
        > {
  $$ObjectRelationsTableTableManager(
    _$AppDatabase db,
    $ObjectRelationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObjectRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObjectRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObjectRelationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> parentObjectId = const Value.absent(),
                Value<String> childObjectId = const Value.absent(),
                Value<String> relationType = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObjectRelationsCompanion(
                id: id,
                parentObjectId: parentObjectId,
                childObjectId: childObjectId,
                relationType: relationType,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String parentObjectId,
                required String childObjectId,
                Value<String> relationType = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObjectRelationsCompanion.insert(
                id: id,
                parentObjectId: parentObjectId,
                childObjectId: childObjectId,
                relationType: relationType,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ObjectRelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ObjectRelationsTable,
      ObjectRelation,
      $$ObjectRelationsTableFilterComposer,
      $$ObjectRelationsTableOrderingComposer,
      $$ObjectRelationsTableAnnotationComposer,
      $$ObjectRelationsTableCreateCompanionBuilder,
      $$ObjectRelationsTableUpdateCompanionBuilder,
      (
        ObjectRelation,
        BaseReferences<_$AppDatabase, $ObjectRelationsTable, ObjectRelation>,
      ),
      ObjectRelation,
      PrefetchHooks Function()
    >;
typedef $$ComponentsTableCreateCompanionBuilder =
    ComponentsCompanion Function({
      required String id,
      required String objectId,
      required String name,
      Value<String?> code,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isRequired,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$ComponentsTableUpdateCompanionBuilder =
    ComponentsCompanion Function({
      Value<String> id,
      Value<String> objectId,
      Value<String> name,
      Value<String?> code,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isRequired,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$ComponentsTableFilterComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objectId => $composableBuilder(
    column: $table.objectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ComponentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objectId => $composableBuilder(
    column: $table.objectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComponentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get objectId =>
      $composableBuilder(column: $table.objectId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ComponentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComponentsTable,
          Component,
          $$ComponentsTableFilterComposer,
          $$ComponentsTableOrderingComposer,
          $$ComponentsTableAnnotationComposer,
          $$ComponentsTableCreateCompanionBuilder,
          $$ComponentsTableUpdateCompanionBuilder,
          (
            Component,
            BaseReferences<_$AppDatabase, $ComponentsTable, Component>,
          ),
          Component,
          PrefetchHooks Function()
        > {
  $$ComponentsTableTableManager(_$AppDatabase db, $ComponentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComponentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComponentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComponentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> objectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentsCompanion(
                id: id,
                objectId: objectId,
                name: name,
                code: code,
                description: description,
                sortOrder: sortOrder,
                isRequired: isRequired,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String objectId,
                required String name,
                Value<String?> code = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentsCompanion.insert(
                id: id,
                objectId: objectId,
                name: name,
                code: code,
                description: description,
                sortOrder: sortOrder,
                isRequired: isRequired,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ComponentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComponentsTable,
      Component,
      $$ComponentsTableFilterComposer,
      $$ComponentsTableOrderingComposer,
      $$ComponentsTableAnnotationComposer,
      $$ComponentsTableCreateCompanionBuilder,
      $$ComponentsTableUpdateCompanionBuilder,
      (Component, BaseReferences<_$AppDatabase, $ComponentsTable, Component>),
      Component,
      PrefetchHooks Function()
    >;
typedef $$ChecklistsTableCreateCompanionBuilder =
    ChecklistsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<bool> isActive,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$ChecklistsTableUpdateCompanionBuilder =
    ChecklistsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<bool> isActive,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$ChecklistsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistsTable> {
  $$ChecklistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChecklistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistsTable> {
  $$ChecklistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChecklistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistsTable> {
  $$ChecklistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ChecklistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistsTable,
          Checklist,
          $$ChecklistsTableFilterComposer,
          $$ChecklistsTableOrderingComposer,
          $$ChecklistsTableAnnotationComposer,
          $$ChecklistsTableCreateCompanionBuilder,
          $$ChecklistsTableUpdateCompanionBuilder,
          (
            Checklist,
            BaseReferences<_$AppDatabase, $ChecklistsTable, Checklist>,
          ),
          Checklist,
          PrefetchHooks Function()
        > {
  $$ChecklistsTableTableManager(_$AppDatabase db, $ChecklistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistsCompanion(
                id: id,
                name: name,
                description: description,
                isActive: isActive,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistsCompanion.insert(
                id: id,
                name: name,
                description: description,
                isActive: isActive,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChecklistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistsTable,
      Checklist,
      $$ChecklistsTableFilterComposer,
      $$ChecklistsTableOrderingComposer,
      $$ChecklistsTableAnnotationComposer,
      $$ChecklistsTableCreateCompanionBuilder,
      $$ChecklistsTableUpdateCompanionBuilder,
      (Checklist, BaseReferences<_$AppDatabase, $ChecklistsTable, Checklist>),
      Checklist,
      PrefetchHooks Function()
    >;
typedef $$ChecklistItemsTableCreateCompanionBuilder =
    ChecklistItemsCompanion Function({
      required String id,
      required String checklistId,
      Value<String?> componentId,
      required String title,
      Value<String?> description,
      Value<String?> expectedResult,
      Value<String> resultType,
      Value<bool> isRequired,
      Value<int> sortOrder,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$ChecklistItemsTableUpdateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<String> id,
      Value<String> checklistId,
      Value<String?> componentId,
      Value<String> title,
      Value<String?> description,
      Value<String?> expectedResult,
      Value<String> resultType,
      Value<bool> isRequired,
      Value<int> sortOrder,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$ChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checklistId => $composableBuilder(
    column: $table.checklistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectedResult => $composableBuilder(
    column: $table.expectedResult,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultType => $composableBuilder(
    column: $table.resultType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checklistId => $composableBuilder(
    column: $table.checklistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedResult => $composableBuilder(
    column: $table.expectedResult,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultType => $composableBuilder(
    column: $table.resultType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get checklistId => $composableBuilder(
    column: $table.checklistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expectedResult => $composableBuilder(
    column: $table.expectedResult,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultType => $composableBuilder(
    column: $table.resultType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ChecklistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistItemsTable,
          ChecklistItem,
          $$ChecklistItemsTableFilterComposer,
          $$ChecklistItemsTableOrderingComposer,
          $$ChecklistItemsTableAnnotationComposer,
          $$ChecklistItemsTableCreateCompanionBuilder,
          $$ChecklistItemsTableUpdateCompanionBuilder,
          (
            ChecklistItem,
            BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItem>,
          ),
          ChecklistItem,
          PrefetchHooks Function()
        > {
  $$ChecklistItemsTableTableManager(
    _$AppDatabase db,
    $ChecklistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> checklistId = const Value.absent(),
                Value<String?> componentId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> expectedResult = const Value.absent(),
                Value<String> resultType = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistItemsCompanion(
                id: id,
                checklistId: checklistId,
                componentId: componentId,
                title: title,
                description: description,
                expectedResult: expectedResult,
                resultType: resultType,
                isRequired: isRequired,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String checklistId,
                Value<String?> componentId = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> expectedResult = const Value.absent(),
                Value<String> resultType = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistItemsCompanion.insert(
                id: id,
                checklistId: checklistId,
                componentId: componentId,
                title: title,
                description: description,
                expectedResult: expectedResult,
                resultType: resultType,
                isRequired: isRequired,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChecklistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistItemsTable,
      ChecklistItem,
      $$ChecklistItemsTableFilterComposer,
      $$ChecklistItemsTableOrderingComposer,
      $$ChecklistItemsTableAnnotationComposer,
      $$ChecklistItemsTableCreateCompanionBuilder,
      $$ChecklistItemsTableUpdateCompanionBuilder,
      (
        ChecklistItem,
        BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItem>,
      ),
      ChecklistItem,
      PrefetchHooks Function()
    >;
typedef $$ChecklistBindingsTableCreateCompanionBuilder =
    ChecklistBindingsCompanion Function({
      required String id,
      required String checklistId,
      required String targetType,
      Value<String?> targetId,
      Value<String?> targetObjectType,
      Value<int> priority,
      Value<bool> isRequired,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$ChecklistBindingsTableUpdateCompanionBuilder =
    ChecklistBindingsCompanion Function({
      Value<String> id,
      Value<String> checklistId,
      Value<String> targetType,
      Value<String?> targetId,
      Value<String?> targetObjectType,
      Value<int> priority,
      Value<bool> isRequired,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$ChecklistBindingsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistBindingsTable> {
  $$ChecklistBindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checklistId => $composableBuilder(
    column: $table.checklistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetObjectType => $composableBuilder(
    column: $table.targetObjectType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChecklistBindingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistBindingsTable> {
  $$ChecklistBindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checklistId => $composableBuilder(
    column: $table.checklistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetObjectType => $composableBuilder(
    column: $table.targetObjectType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChecklistBindingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistBindingsTable> {
  $$ChecklistBindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get checklistId => $composableBuilder(
    column: $table.checklistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get targetObjectType => $composableBuilder(
    column: $table.targetObjectType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ChecklistBindingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistBindingsTable,
          ChecklistBinding,
          $$ChecklistBindingsTableFilterComposer,
          $$ChecklistBindingsTableOrderingComposer,
          $$ChecklistBindingsTableAnnotationComposer,
          $$ChecklistBindingsTableCreateCompanionBuilder,
          $$ChecklistBindingsTableUpdateCompanionBuilder,
          (
            ChecklistBinding,
            BaseReferences<
              _$AppDatabase,
              $ChecklistBindingsTable,
              ChecklistBinding
            >,
          ),
          ChecklistBinding,
          PrefetchHooks Function()
        > {
  $$ChecklistBindingsTableTableManager(
    _$AppDatabase db,
    $ChecklistBindingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistBindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistBindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistBindingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> checklistId = const Value.absent(),
                Value<String> targetType = const Value.absent(),
                Value<String?> targetId = const Value.absent(),
                Value<String?> targetObjectType = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistBindingsCompanion(
                id: id,
                checklistId: checklistId,
                targetType: targetType,
                targetId: targetId,
                targetObjectType: targetObjectType,
                priority: priority,
                isRequired: isRequired,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String checklistId,
                required String targetType,
                Value<String?> targetId = const Value.absent(),
                Value<String?> targetObjectType = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistBindingsCompanion.insert(
                id: id,
                checklistId: checklistId,
                targetType: targetType,
                targetId: targetId,
                targetObjectType: targetObjectType,
                priority: priority,
                isRequired: isRequired,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChecklistBindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistBindingsTable,
      ChecklistBinding,
      $$ChecklistBindingsTableFilterComposer,
      $$ChecklistBindingsTableOrderingComposer,
      $$ChecklistBindingsTableAnnotationComposer,
      $$ChecklistBindingsTableCreateCompanionBuilder,
      $$ChecklistBindingsTableUpdateCompanionBuilder,
      (
        ChecklistBinding,
        BaseReferences<
          _$AppDatabase,
          $ChecklistBindingsTable,
          ChecklistBinding
        >,
      ),
      ChecklistBinding,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      required String id,
      required String deviceId,
      Value<String?> lastReferencePackageId,
      Value<String?> lastReferenceSyncAt,
      Value<String?> lastResultPushAt,
      Value<String?> lastResultPullAt,
      Value<String?> lastSuccessAt,
      Value<String?> lastError,
      required String schemaVersion,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<String> id,
      Value<String> deviceId,
      Value<String?> lastReferencePackageId,
      Value<String?> lastReferenceSyncAt,
      Value<String?> lastResultPushAt,
      Value<String?> lastResultPullAt,
      Value<String?> lastSuccessAt,
      Value<String?> lastError,
      Value<String> schemaVersion,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastReferencePackageId => $composableBuilder(
    column: $table.lastReferencePackageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastReferenceSyncAt => $composableBuilder(
    column: $table.lastReferenceSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastResultPushAt => $composableBuilder(
    column: $table.lastResultPushAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastResultPullAt => $composableBuilder(
    column: $table.lastResultPullAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastReferencePackageId => $composableBuilder(
    column: $table.lastReferencePackageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastReferenceSyncAt => $composableBuilder(
    column: $table.lastReferenceSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastResultPushAt => $composableBuilder(
    column: $table.lastResultPushAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastResultPullAt => $composableBuilder(
    column: $table.lastResultPullAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get lastReferencePackageId => $composableBuilder(
    column: $table.lastReferencePackageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastReferenceSyncAt => $composableBuilder(
    column: $table.lastReferenceSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastResultPushAt => $composableBuilder(
    column: $table.lastResultPushAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastResultPullAt => $composableBuilder(
    column: $table.lastResultPullAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String?> lastReferencePackageId = const Value.absent(),
                Value<String?> lastReferenceSyncAt = const Value.absent(),
                Value<String?> lastResultPushAt = const Value.absent(),
                Value<String?> lastResultPullAt = const Value.absent(),
                Value<String?> lastSuccessAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> schemaVersion = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(
                id: id,
                deviceId: deviceId,
                lastReferencePackageId: lastReferencePackageId,
                lastReferenceSyncAt: lastReferenceSyncAt,
                lastResultPushAt: lastResultPushAt,
                lastResultPullAt: lastResultPullAt,
                lastSuccessAt: lastSuccessAt,
                lastError: lastError,
                schemaVersion: schemaVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deviceId,
                Value<String?> lastReferencePackageId = const Value.absent(),
                Value<String?> lastReferenceSyncAt = const Value.absent(),
                Value<String?> lastResultPushAt = const Value.absent(),
                Value<String?> lastResultPullAt = const Value.absent(),
                Value<String?> lastSuccessAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required String schemaVersion,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                id: id,
                deviceId: deviceId,
                lastReferencePackageId: lastReferencePackageId,
                lastReferenceSyncAt: lastReferenceSyncAt,
                lastResultPushAt: lastResultPushAt,
                lastResultPullAt: lastResultPullAt,
                lastSuccessAt: lastSuccessAt,
                lastError: lastError,
                schemaVersion: schemaVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateData,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
      ),
      SyncStateData,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      required String id,
      required String direction,
      required String packageType,
      required String packageId,
      required String localPath,
      required String status,
      Value<int> attemptCount,
      Value<String?> nextAttemptAt,
      Value<String?> lastError,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      Value<String> direction,
      Value<String> packageType,
      Value<String> packageId,
      Value<String> localPath,
      Value<String> status,
      Value<int> attemptCount,
      Value<String?> nextAttemptAt,
      Value<String?> lastError,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageType => $composableBuilder(
    column: $table.packageType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageId => $composableBuilder(
    column: $table.packageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageType => $composableBuilder(
    column: $table.packageType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageId => $composableBuilder(
    column: $table.packageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get packageType => $composableBuilder(
    column: $table.packageType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get packageId =>
      $composableBuilder(column: $table.packageId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> packageType = const Value.absent(),
                Value<String> packageId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                direction: direction,
                packageType: packageType,
                packageId: packageId,
                localPath: localPath,
                status: status,
                attemptCount: attemptCount,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String direction,
                required String packageType,
                required String packageId,
                required String localPath,
                required String status,
                Value<int> attemptCount = const Value.absent(),
                Value<String?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                direction: direction,
                packageType: packageType,
                packageId: packageId,
                localPath: localPath,
                status: status,
                attemptCount: attemptCount,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$LocksTableCreateCompanionBuilder =
    LocksCompanion Function({
      required String id,
      required String productObjectId,
      required String remoteLockKey,
      required String deviceId,
      required String userId,
      required String status,
      required String acquiredAt,
      required String expiresAt,
      Value<String?> releasedAt,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$LocksTableUpdateCompanionBuilder =
    LocksCompanion Function({
      Value<String> id,
      Value<String> productObjectId,
      Value<String> remoteLockKey,
      Value<String> deviceId,
      Value<String> userId,
      Value<String> status,
      Value<String> acquiredAt,
      Value<String> expiresAt,
      Value<String?> releasedAt,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$LocksTableFilterComposer extends Composer<_$AppDatabase, $LocksTable> {
  $$LocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productObjectId => $composableBuilder(
    column: $table.productObjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteLockKey => $composableBuilder(
    column: $table.remoteLockKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocksTableOrderingComposer
    extends Composer<_$AppDatabase, $LocksTable> {
  $$LocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productObjectId => $composableBuilder(
    column: $table.productObjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteLockKey => $composableBuilder(
    column: $table.remoteLockKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocksTable> {
  $$LocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productObjectId => $composableBuilder(
    column: $table.productObjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteLockKey => $composableBuilder(
    column: $table.remoteLockKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocksTable,
          Lock,
          $$LocksTableFilterComposer,
          $$LocksTableOrderingComposer,
          $$LocksTableAnnotationComposer,
          $$LocksTableCreateCompanionBuilder,
          $$LocksTableUpdateCompanionBuilder,
          (Lock, BaseReferences<_$AppDatabase, $LocksTable, Lock>),
          Lock,
          PrefetchHooks Function()
        > {
  $$LocksTableTableManager(_$AppDatabase db, $LocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productObjectId = const Value.absent(),
                Value<String> remoteLockKey = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> acquiredAt = const Value.absent(),
                Value<String> expiresAt = const Value.absent(),
                Value<String?> releasedAt = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocksCompanion(
                id: id,
                productObjectId: productObjectId,
                remoteLockKey: remoteLockKey,
                deviceId: deviceId,
                userId: userId,
                status: status,
                acquiredAt: acquiredAt,
                expiresAt: expiresAt,
                releasedAt: releasedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productObjectId,
                required String remoteLockKey,
                required String deviceId,
                required String userId,
                required String status,
                required String acquiredAt,
                required String expiresAt,
                Value<String?> releasedAt = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocksCompanion.insert(
                id: id,
                productObjectId: productObjectId,
                remoteLockKey: remoteLockKey,
                deviceId: deviceId,
                userId: userId,
                status: status,
                acquiredAt: acquiredAt,
                expiresAt: expiresAt,
                releasedAt: releasedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocksTable,
      Lock,
      $$LocksTableFilterComposer,
      $$LocksTableOrderingComposer,
      $$LocksTableAnnotationComposer,
      $$LocksTableCreateCompanionBuilder,
      $$LocksTableUpdateCompanionBuilder,
      (Lock, BaseReferences<_$AppDatabase, $LocksTable, Lock>),
      Lock,
      PrefetchHooks Function()
    >;
typedef $$ComponentImagesTableCreateCompanionBuilder =
    ComponentImagesCompanion Function({
      required String id,
      required String componentId,
      required String fileName,
      required String mediaKey,
      Value<String?> localPath,
      Value<String?> remotePath,
      required String checksum,
      required String mimeType,
      Value<int> sortOrder,
      Value<int?> width,
      Value<int?> height,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$ComponentImagesTableUpdateCompanionBuilder =
    ComponentImagesCompanion Function({
      Value<String> id,
      Value<String> componentId,
      Value<String> fileName,
      Value<String> mediaKey,
      Value<String?> localPath,
      Value<String?> remotePath,
      Value<String> checksum,
      Value<String> mimeType,
      Value<int> sortOrder,
      Value<int?> width,
      Value<int?> height,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$ComponentImagesTableFilterComposer
    extends Composer<_$AppDatabase, $ComponentImagesTable> {
  $$ComponentImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaKey => $composableBuilder(
    column: $table.mediaKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ComponentImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ComponentImagesTable> {
  $$ComponentImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaKey => $composableBuilder(
    column: $table.mediaKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComponentImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComponentImagesTable> {
  $$ComponentImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get mediaKey =>
      $composableBuilder(column: $table.mediaKey, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ComponentImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComponentImagesTable,
          ComponentImage,
          $$ComponentImagesTableFilterComposer,
          $$ComponentImagesTableOrderingComposer,
          $$ComponentImagesTableAnnotationComposer,
          $$ComponentImagesTableCreateCompanionBuilder,
          $$ComponentImagesTableUpdateCompanionBuilder,
          (
            ComponentImage,
            BaseReferences<
              _$AppDatabase,
              $ComponentImagesTable,
              ComponentImage
            >,
          ),
          ComponentImage,
          PrefetchHooks Function()
        > {
  $$ComponentImagesTableTableManager(
    _$AppDatabase db,
    $ComponentImagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComponentImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComponentImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComponentImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> componentId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> mediaKey = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String?> remotePath = const Value.absent(),
                Value<String> checksum = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentImagesCompanion(
                id: id,
                componentId: componentId,
                fileName: fileName,
                mediaKey: mediaKey,
                localPath: localPath,
                remotePath: remotePath,
                checksum: checksum,
                mimeType: mimeType,
                sortOrder: sortOrder,
                width: width,
                height: height,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String componentId,
                required String fileName,
                required String mediaKey,
                Value<String?> localPath = const Value.absent(),
                Value<String?> remotePath = const Value.absent(),
                required String checksum,
                required String mimeType,
                Value<int> sortOrder = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentImagesCompanion.insert(
                id: id,
                componentId: componentId,
                fileName: fileName,
                mediaKey: mediaKey,
                localPath: localPath,
                remotePath: remotePath,
                checksum: checksum,
                mimeType: mimeType,
                sortOrder: sortOrder,
                width: width,
                height: height,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ComponentImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComponentImagesTable,
      ComponentImage,
      $$ComponentImagesTableFilterComposer,
      $$ComponentImagesTableOrderingComposer,
      $$ComponentImagesTableAnnotationComposer,
      $$ComponentImagesTableCreateCompanionBuilder,
      $$ComponentImagesTableUpdateCompanionBuilder,
      (
        ComponentImage,
        BaseReferences<_$AppDatabase, $ComponentImagesTable, ComponentImage>,
      ),
      ComponentImage,
      PrefetchHooks Function()
    >;
typedef $$InspectionsTableCreateCompanionBuilder =
    InspectionsCompanion Function({
      required String id,
      required String deviceId,
      required String userId,
      required String productObjectId,
      required String targetObjectId,
      required String startedAt,
      Value<String?> completedAt,
      required String status,
      required String syncStatus,
      Value<String?> sourceReferencePackageId,
      Value<String?> sourceReferenceVersion,
      Value<String?> pdfLocalPath,
      Value<String?> pdfChecksum,
      Value<String?> conflictReason,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$InspectionsTableUpdateCompanionBuilder =
    InspectionsCompanion Function({
      Value<String> id,
      Value<String> deviceId,
      Value<String> userId,
      Value<String> productObjectId,
      Value<String> targetObjectId,
      Value<String> startedAt,
      Value<String?> completedAt,
      Value<String> status,
      Value<String> syncStatus,
      Value<String?> sourceReferencePackageId,
      Value<String?> sourceReferenceVersion,
      Value<String?> pdfLocalPath,
      Value<String?> pdfChecksum,
      Value<String?> conflictReason,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$InspectionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productObjectId => $composableBuilder(
    column: $table.productObjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetObjectId => $composableBuilder(
    column: $table.targetObjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReferencePackageId => $composableBuilder(
    column: $table.sourceReferencePackageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReferenceVersion => $composableBuilder(
    column: $table.sourceReferenceVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfLocalPath => $composableBuilder(
    column: $table.pdfLocalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfChecksum => $composableBuilder(
    column: $table.pdfChecksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictReason => $composableBuilder(
    column: $table.conflictReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productObjectId => $composableBuilder(
    column: $table.productObjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetObjectId => $composableBuilder(
    column: $table.targetObjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReferencePackageId => $composableBuilder(
    column: $table.sourceReferencePackageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReferenceVersion => $composableBuilder(
    column: $table.sourceReferenceVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfLocalPath => $composableBuilder(
    column: $table.pdfLocalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfChecksum => $composableBuilder(
    column: $table.pdfChecksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictReason => $composableBuilder(
    column: $table.conflictReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get productObjectId => $composableBuilder(
    column: $table.productObjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetObjectId => $composableBuilder(
    column: $table.targetObjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReferencePackageId => $composableBuilder(
    column: $table.sourceReferencePackageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReferenceVersion => $composableBuilder(
    column: $table.sourceReferenceVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pdfLocalPath => $composableBuilder(
    column: $table.pdfLocalPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pdfChecksum => $composableBuilder(
    column: $table.pdfChecksum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictReason => $composableBuilder(
    column: $table.conflictReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InspectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionsTable,
          Inspection,
          $$InspectionsTableFilterComposer,
          $$InspectionsTableOrderingComposer,
          $$InspectionsTableAnnotationComposer,
          $$InspectionsTableCreateCompanionBuilder,
          $$InspectionsTableUpdateCompanionBuilder,
          (
            Inspection,
            BaseReferences<_$AppDatabase, $InspectionsTable, Inspection>,
          ),
          Inspection,
          PrefetchHooks Function()
        > {
  $$InspectionsTableTableManager(_$AppDatabase db, $InspectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> productObjectId = const Value.absent(),
                Value<String> targetObjectId = const Value.absent(),
                Value<String> startedAt = const Value.absent(),
                Value<String?> completedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> sourceReferencePackageId = const Value.absent(),
                Value<String?> sourceReferenceVersion = const Value.absent(),
                Value<String?> pdfLocalPath = const Value.absent(),
                Value<String?> pdfChecksum = const Value.absent(),
                Value<String?> conflictReason = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion(
                id: id,
                deviceId: deviceId,
                userId: userId,
                productObjectId: productObjectId,
                targetObjectId: targetObjectId,
                startedAt: startedAt,
                completedAt: completedAt,
                status: status,
                syncStatus: syncStatus,
                sourceReferencePackageId: sourceReferencePackageId,
                sourceReferenceVersion: sourceReferenceVersion,
                pdfLocalPath: pdfLocalPath,
                pdfChecksum: pdfChecksum,
                conflictReason: conflictReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deviceId,
                required String userId,
                required String productObjectId,
                required String targetObjectId,
                required String startedAt,
                Value<String?> completedAt = const Value.absent(),
                required String status,
                required String syncStatus,
                Value<String?> sourceReferencePackageId = const Value.absent(),
                Value<String?> sourceReferenceVersion = const Value.absent(),
                Value<String?> pdfLocalPath = const Value.absent(),
                Value<String?> pdfChecksum = const Value.absent(),
                Value<String?> conflictReason = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion.insert(
                id: id,
                deviceId: deviceId,
                userId: userId,
                productObjectId: productObjectId,
                targetObjectId: targetObjectId,
                startedAt: startedAt,
                completedAt: completedAt,
                status: status,
                syncStatus: syncStatus,
                sourceReferencePackageId: sourceReferencePackageId,
                sourceReferenceVersion: sourceReferenceVersion,
                pdfLocalPath: pdfLocalPath,
                pdfChecksum: pdfChecksum,
                conflictReason: conflictReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionsTable,
      Inspection,
      $$InspectionsTableFilterComposer,
      $$InspectionsTableOrderingComposer,
      $$InspectionsTableAnnotationComposer,
      $$InspectionsTableCreateCompanionBuilder,
      $$InspectionsTableUpdateCompanionBuilder,
      (
        Inspection,
        BaseReferences<_$AppDatabase, $InspectionsTable, Inspection>,
      ),
      Inspection,
      PrefetchHooks Function()
    >;
typedef $$InspectionItemsTableCreateCompanionBuilder =
    InspectionItemsCompanion Function({
      required String id,
      required String inspectionId,
      required String checklistItemId,
      Value<String?> componentId,
      Value<String> resultStatus,
      Value<String?> comment,
      Value<String?> measuredValue,
      Value<int> sortOrder,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$InspectionItemsTableUpdateCompanionBuilder =
    InspectionItemsCompanion Function({
      Value<String> id,
      Value<String> inspectionId,
      Value<String> checklistItemId,
      Value<String?> componentId,
      Value<String> resultStatus,
      Value<String?> comment,
      Value<String?> measuredValue,
      Value<int> sortOrder,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$InspectionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionItemsTable> {
  $$InspectionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checklistItemId => $composableBuilder(
    column: $table.checklistItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultStatus => $composableBuilder(
    column: $table.resultStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measuredValue => $composableBuilder(
    column: $table.measuredValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionItemsTable> {
  $$InspectionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checklistItemId => $composableBuilder(
    column: $table.checklistItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultStatus => $composableBuilder(
    column: $table.resultStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measuredValue => $composableBuilder(
    column: $table.measuredValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionItemsTable> {
  $$InspectionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checklistItemId => $composableBuilder(
    column: $table.checklistItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultStatus => $composableBuilder(
    column: $table.resultStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get measuredValue => $composableBuilder(
    column: $table.measuredValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InspectionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionItemsTable,
          InspectionItem,
          $$InspectionItemsTableFilterComposer,
          $$InspectionItemsTableOrderingComposer,
          $$InspectionItemsTableAnnotationComposer,
          $$InspectionItemsTableCreateCompanionBuilder,
          $$InspectionItemsTableUpdateCompanionBuilder,
          (
            InspectionItem,
            BaseReferences<
              _$AppDatabase,
              $InspectionItemsTable,
              InspectionItem
            >,
          ),
          InspectionItem,
          PrefetchHooks Function()
        > {
  $$InspectionItemsTableTableManager(
    _$AppDatabase db,
    $InspectionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> inspectionId = const Value.absent(),
                Value<String> checklistItemId = const Value.absent(),
                Value<String?> componentId = const Value.absent(),
                Value<String> resultStatus = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<String?> measuredValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionItemsCompanion(
                id: id,
                inspectionId: inspectionId,
                checklistItemId: checklistItemId,
                componentId: componentId,
                resultStatus: resultStatus,
                comment: comment,
                measuredValue: measuredValue,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String inspectionId,
                required String checklistItemId,
                Value<String?> componentId = const Value.absent(),
                Value<String> resultStatus = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<String?> measuredValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InspectionItemsCompanion.insert(
                id: id,
                inspectionId: inspectionId,
                checklistItemId: checklistItemId,
                componentId: componentId,
                resultStatus: resultStatus,
                comment: comment,
                measuredValue: measuredValue,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionItemsTable,
      InspectionItem,
      $$InspectionItemsTableFilterComposer,
      $$InspectionItemsTableOrderingComposer,
      $$InspectionItemsTableAnnotationComposer,
      $$InspectionItemsTableCreateCompanionBuilder,
      $$InspectionItemsTableUpdateCompanionBuilder,
      (
        InspectionItem,
        BaseReferences<_$AppDatabase, $InspectionItemsTable, InspectionItem>,
      ),
      InspectionItem,
      PrefetchHooks Function()
    >;
typedef $$InspectionSignaturesTableCreateCompanionBuilder =
    InspectionSignaturesCompanion Function({
      required String id,
      required String inspectionId,
      Value<String?> signerUserId,
      required String signerName,
      required String signerRole,
      required String imageLocalPath,
      required String checksum,
      required String signedAt,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$InspectionSignaturesTableUpdateCompanionBuilder =
    InspectionSignaturesCompanion Function({
      Value<String> id,
      Value<String> inspectionId,
      Value<String?> signerUserId,
      Value<String> signerName,
      Value<String> signerRole,
      Value<String> imageLocalPath,
      Value<String> checksum,
      Value<String> signedAt,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$InspectionSignaturesTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionSignaturesTable> {
  $$InspectionSignaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signerUserId => $composableBuilder(
    column: $table.signerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signerName => $composableBuilder(
    column: $table.signerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signerRole => $composableBuilder(
    column: $table.signerRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageLocalPath => $composableBuilder(
    column: $table.imageLocalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionSignaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionSignaturesTable> {
  $$InspectionSignaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signerUserId => $composableBuilder(
    column: $table.signerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signerName => $composableBuilder(
    column: $table.signerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signerRole => $composableBuilder(
    column: $table.signerRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageLocalPath => $composableBuilder(
    column: $table.imageLocalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionSignaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionSignaturesTable> {
  $$InspectionSignaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signerUserId => $composableBuilder(
    column: $table.signerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signerName => $composableBuilder(
    column: $table.signerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signerRole => $composableBuilder(
    column: $table.signerRole,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageLocalPath => $composableBuilder(
    column: $table.imageLocalPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<String> get signedAt =>
      $composableBuilder(column: $table.signedAt, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InspectionSignaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionSignaturesTable,
          InspectionSignature,
          $$InspectionSignaturesTableFilterComposer,
          $$InspectionSignaturesTableOrderingComposer,
          $$InspectionSignaturesTableAnnotationComposer,
          $$InspectionSignaturesTableCreateCompanionBuilder,
          $$InspectionSignaturesTableUpdateCompanionBuilder,
          (
            InspectionSignature,
            BaseReferences<
              _$AppDatabase,
              $InspectionSignaturesTable,
              InspectionSignature
            >,
          ),
          InspectionSignature,
          PrefetchHooks Function()
        > {
  $$InspectionSignaturesTableTableManager(
    _$AppDatabase db,
    $InspectionSignaturesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionSignaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionSignaturesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InspectionSignaturesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> inspectionId = const Value.absent(),
                Value<String?> signerUserId = const Value.absent(),
                Value<String> signerName = const Value.absent(),
                Value<String> signerRole = const Value.absent(),
                Value<String> imageLocalPath = const Value.absent(),
                Value<String> checksum = const Value.absent(),
                Value<String> signedAt = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionSignaturesCompanion(
                id: id,
                inspectionId: inspectionId,
                signerUserId: signerUserId,
                signerName: signerName,
                signerRole: signerRole,
                imageLocalPath: imageLocalPath,
                checksum: checksum,
                signedAt: signedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String inspectionId,
                Value<String?> signerUserId = const Value.absent(),
                required String signerName,
                required String signerRole,
                required String imageLocalPath,
                required String checksum,
                required String signedAt,
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InspectionSignaturesCompanion.insert(
                id: id,
                inspectionId: inspectionId,
                signerUserId: signerUserId,
                signerName: signerName,
                signerRole: signerRole,
                imageLocalPath: imageLocalPath,
                checksum: checksum,
                signedAt: signedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionSignaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionSignaturesTable,
      InspectionSignature,
      $$InspectionSignaturesTableFilterComposer,
      $$InspectionSignaturesTableOrderingComposer,
      $$InspectionSignaturesTableAnnotationComposer,
      $$InspectionSignaturesTableCreateCompanionBuilder,
      $$InspectionSignaturesTableUpdateCompanionBuilder,
      (
        InspectionSignature,
        BaseReferences<
          _$AppDatabase,
          $InspectionSignaturesTable,
          InspectionSignature
        >,
      ),
      InspectionSignature,
      PrefetchHooks Function()
    >;
typedef $$InspectionFilesTableCreateCompanionBuilder =
    InspectionFilesCompanion Function({
      required String id,
      required String inspectionId,
      required String fileType,
      required String fileName,
      required String localPath,
      required String checksum,
      required String mimeType,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$InspectionFilesTableUpdateCompanionBuilder =
    InspectionFilesCompanion Function({
      Value<String> id,
      Value<String> inspectionId,
      Value<String> fileType,
      Value<String> fileName,
      Value<String> localPath,
      Value<String> checksum,
      Value<String> mimeType,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$InspectionFilesTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionFilesTable> {
  $$InspectionFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionFilesTable> {
  $$InspectionFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionFilesTable> {
  $$InspectionFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InspectionFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionFilesTable,
          InspectionFile,
          $$InspectionFilesTableFilterComposer,
          $$InspectionFilesTableOrderingComposer,
          $$InspectionFilesTableAnnotationComposer,
          $$InspectionFilesTableCreateCompanionBuilder,
          $$InspectionFilesTableUpdateCompanionBuilder,
          (
            InspectionFile,
            BaseReferences<
              _$AppDatabase,
              $InspectionFilesTable,
              InspectionFile
            >,
          ),
          InspectionFile,
          PrefetchHooks Function()
        > {
  $$InspectionFilesTableTableManager(
    _$AppDatabase db,
    $InspectionFilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> inspectionId = const Value.absent(),
                Value<String> fileType = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String> checksum = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionFilesCompanion(
                id: id,
                inspectionId: inspectionId,
                fileType: fileType,
                fileName: fileName,
                localPath: localPath,
                checksum: checksum,
                mimeType: mimeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String inspectionId,
                required String fileType,
                required String fileName,
                required String localPath,
                required String checksum,
                required String mimeType,
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InspectionFilesCompanion.insert(
                id: id,
                inspectionId: inspectionId,
                fileType: fileType,
                fileName: fileName,
                localPath: localPath,
                checksum: checksum,
                mimeType: mimeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionFilesTable,
      InspectionFile,
      $$InspectionFilesTableFilterComposer,
      $$InspectionFilesTableOrderingComposer,
      $$InspectionFilesTableAnnotationComposer,
      $$InspectionFilesTableCreateCompanionBuilder,
      $$InspectionFilesTableUpdateCompanionBuilder,
      (
        InspectionFile,
        BaseReferences<_$AppDatabase, $InspectionFilesTable, InspectionFile>,
      ),
      InspectionFile,
      PrefetchHooks Function()
    >;
typedef $$TrashBinTableCreateCompanionBuilder =
    TrashBinCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String displayName,
      required String snapshotJson,
      Value<String?> deletedByUserId,
      required String deletedAt,
      Value<String?> restoredAt,
      Value<String?> permanentlyDeletedAt,
      Value<int> rowid,
    });
typedef $$TrashBinTableUpdateCompanionBuilder =
    TrashBinCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> displayName,
      Value<String> snapshotJson,
      Value<String?> deletedByUserId,
      Value<String> deletedAt,
      Value<String?> restoredAt,
      Value<String?> permanentlyDeletedAt,
      Value<int> rowid,
    });

class $$TrashBinTableFilterComposer
    extends Composer<_$AppDatabase, $TrashBinTable> {
  $$TrashBinTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedByUserId => $composableBuilder(
    column: $table.deletedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get restoredAt => $composableBuilder(
    column: $table.restoredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permanentlyDeletedAt => $composableBuilder(
    column: $table.permanentlyDeletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrashBinTableOrderingComposer
    extends Composer<_$AppDatabase, $TrashBinTable> {
  $$TrashBinTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedByUserId => $composableBuilder(
    column: $table.deletedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get restoredAt => $composableBuilder(
    column: $table.restoredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permanentlyDeletedAt => $composableBuilder(
    column: $table.permanentlyDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrashBinTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrashBinTable> {
  $$TrashBinTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deletedByUserId => $composableBuilder(
    column: $table.deletedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get restoredAt => $composableBuilder(
    column: $table.restoredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permanentlyDeletedAt => $composableBuilder(
    column: $table.permanentlyDeletedAt,
    builder: (column) => column,
  );
}

class $$TrashBinTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrashBinTable,
          TrashBinData,
          $$TrashBinTableFilterComposer,
          $$TrashBinTableOrderingComposer,
          $$TrashBinTableAnnotationComposer,
          $$TrashBinTableCreateCompanionBuilder,
          $$TrashBinTableUpdateCompanionBuilder,
          (
            TrashBinData,
            BaseReferences<_$AppDatabase, $TrashBinTable, TrashBinData>,
          ),
          TrashBinData,
          PrefetchHooks Function()
        > {
  $$TrashBinTableTableManager(_$AppDatabase db, $TrashBinTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrashBinTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrashBinTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrashBinTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> snapshotJson = const Value.absent(),
                Value<String?> deletedByUserId = const Value.absent(),
                Value<String> deletedAt = const Value.absent(),
                Value<String?> restoredAt = const Value.absent(),
                Value<String?> permanentlyDeletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrashBinCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                displayName: displayName,
                snapshotJson: snapshotJson,
                deletedByUserId: deletedByUserId,
                deletedAt: deletedAt,
                restoredAt: restoredAt,
                permanentlyDeletedAt: permanentlyDeletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String displayName,
                required String snapshotJson,
                Value<String?> deletedByUserId = const Value.absent(),
                required String deletedAt,
                Value<String?> restoredAt = const Value.absent(),
                Value<String?> permanentlyDeletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrashBinCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                displayName: displayName,
                snapshotJson: snapshotJson,
                deletedByUserId: deletedByUserId,
                deletedAt: deletedAt,
                restoredAt: restoredAt,
                permanentlyDeletedAt: permanentlyDeletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrashBinTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrashBinTable,
      TrashBinData,
      $$TrashBinTableFilterComposer,
      $$TrashBinTableOrderingComposer,
      $$TrashBinTableAnnotationComposer,
      $$TrashBinTableCreateCompanionBuilder,
      $$TrashBinTableUpdateCompanionBuilder,
      (
        TrashBinData,
        BaseReferences<_$AppDatabase, $TrashBinTable, TrashBinData>,
      ),
      TrashBinData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RolesTableTableManager get roles =>
      $$RolesTableTableManager(_db, _db.roles);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$DeviceInfoTableTableManager get deviceInfo =>
      $$DeviceInfoTableTableManager(_db, _db.deviceInfo);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$DepartmentsTableTableManager get departments =>
      $$DepartmentsTableTableManager(_db, _db.departments);
  $$WorkshopsTableTableManager get workshops =>
      $$WorkshopsTableTableManager(_db, _db.workshops);
  $$SectionsTableTableManager get sections =>
      $$SectionsTableTableManager(_db, _db.sections);
  $$CatalogObjectsTableTableManager get catalogObjects =>
      $$CatalogObjectsTableTableManager(_db, _db.catalogObjects);
  $$ObjectRelationsTableTableManager get objectRelations =>
      $$ObjectRelationsTableTableManager(_db, _db.objectRelations);
  $$ComponentsTableTableManager get components =>
      $$ComponentsTableTableManager(_db, _db.components);
  $$ChecklistsTableTableManager get checklists =>
      $$ChecklistsTableTableManager(_db, _db.checklists);
  $$ChecklistItemsTableTableManager get checklistItems =>
      $$ChecklistItemsTableTableManager(_db, _db.checklistItems);
  $$ChecklistBindingsTableTableManager get checklistBindings =>
      $$ChecklistBindingsTableTableManager(_db, _db.checklistBindings);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$LocksTableTableManager get locks =>
      $$LocksTableTableManager(_db, _db.locks);
  $$ComponentImagesTableTableManager get componentImages =>
      $$ComponentImagesTableTableManager(_db, _db.componentImages);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db, _db.inspections);
  $$InspectionItemsTableTableManager get inspectionItems =>
      $$InspectionItemsTableTableManager(_db, _db.inspectionItems);
  $$InspectionSignaturesTableTableManager get inspectionSignatures =>
      $$InspectionSignaturesTableTableManager(_db, _db.inspectionSignatures);
  $$InspectionFilesTableTableManager get inspectionFiles =>
      $$InspectionFilesTableTableManager(_db, _db.inspectionFiles);
  $$TrashBinTableTableManager get trashBin =>
      $$TrashBinTableTableManager(_db, _db.trashBin);
}
