import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart' as drift;

import '../../core/auth/app_permissions.dart';
import 'app_database.dart';

String nullableText(String? value) {
  if (value == null) {
    return '';
  }

  return value.trim();
}

String? nullableField(String? value) {
  final cleaned = nullableText(value);
  return cleaned.isEmpty ? null : cleaned;
}

String nowIso() => DateTime.now().toUtc().toIso8601String();

final Random _random = Random();

String generateId(String prefix) {
  final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch.toRadixString(
    36,
  );
  final suffix = _random.nextInt(1 << 32).toRadixString(36);
  return '$prefix-$timestamp-$suffix';
}

Future<void> recordAudit(
  AppDatabase db, {
  required String actionType,
  required String resultStatus,
  String? userId,
  String? deviceId,
  String? entityType,
  String? entityId,
  String? message,
  Object? payload,
}) {
  return db
      .into(db.auditLog)
      .insert(
        AuditLogCompanion.insert(
          id: generateId('audit'),
          happenedAt: nowIso(),
          userId: driftValue(userId),
          deviceId: driftValue(deviceId),
          actionType: actionType,
          entityType: driftValue(entityType),
          entityId: driftValue(entityId),
          resultStatus: resultStatus,
          message: driftValue(message),
          payloadJson: payload == null
              ? const drift.Value.absent()
              : drift.Value(jsonEncode(payload)),
        ),
      );
}

drift.Value<String> driftValue(String? value) {
  return value == null ? const drift.Value.absent() : drift.Value(value);
}

Future<void> addTrashEntry(
  AppDatabase db, {
  required String entityType,
  required String entityId,
  required String displayName,
  required Object snapshot,
  String? deletedByUserId,
  String? deletedAt,
}) {
  return db
      .into(db.trashBin)
      .insert(
        TrashBinCompanion.insert(
          id: generateId('trash'),
          entityType: entityType,
          entityId: entityId,
          displayName: displayName,
          snapshotJson: jsonEncode(snapshot),
          deletedByUserId: driftValue(deletedByUserId),
          deletedAt: deletedAt ?? nowIso(),
        ),
      );
}

String? firstWords(String? value, [int limit = 2]) {
  final cleaned = nullableField(value);
  if (cleaned == null) {
    return null;
  }

  final words = cleaned.split(RegExp(r'\s+'));
  return words.take(limit).join(' ');
}

String pinHash(String pin) {
  final bytes = utf8.encode('okk-pin::$pin');
  var hash = 2166136261;

  for (final byte in bytes) {
    hash ^= byte;
    hash = (hash * 16777619) & 0xFFFFFFFF;
  }

  return hash.toRadixString(16).padLeft(8, '0');
}

Future<String?> loadUserRoleCode(AppDatabase db, String userId) async {
  final user =
      await (db.select(db.users)..where(
            (tbl) =>
                tbl.id.equals(userId) &
                tbl.isDeleted.equals(false) &
                tbl.isActive.equals(true),
          ))
          .getSingleOrNull();
  if (user == null) {
    return null;
  }

  final role = await (db.select(
    db.roles,
  )..where((tbl) => tbl.id.equals(user.roleId))).getSingleOrNull();
  return role?.code;
}

Future<void> requireUserCapability(
  AppDatabase db, {
  required String? actorUserId,
  required AppCapability capability,
  required String deniedMessage,
}) async {
  if (actorUserId == null) {
    return;
  }

  final roleCode = await loadUserRoleCode(db, actorUserId);
  if (!roleHasCapability(roleCode, capability)) {
    throw StateError(deniedMessage);
  }
}
