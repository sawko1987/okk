import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/sqlite/app_database.dart';
import '../../../data/sqlite/database_provider.dart';
import '../../../data/sqlite/repository_support.dart';

class AuthSession {
  const AuthSession({
    required this.userId,
    required this.fullName,
    required this.roleId,
    required this.roleCode,
    required this.roleName,
  });

  final String userId;
  final String fullName;
  final String roleId;
  final String roleCode;
  final String roleName;
}

class LoginUserOption {
  const LoginUserOption({
    required this.userId,
    required this.fullName,
    required this.shortName,
    required this.roleCode,
    required this.roleName,
    required this.requiresPin,
  });

  final String userId;
  final String fullName;
  final String? shortName;
  final String roleCode;
  final String roleName;
  final bool requiresPin;
}

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(appDatabaseProvider)),
);

final _authRefreshKeyProvider = StateProvider<int>((ref) => 0);

final activeSessionProvider = FutureProvider<AuthSession?>((ref) async {
  ref.watch(_authRefreshKeyProvider);
  return ref.watch(authServiceProvider).currentSession();
});

final loginUsersProvider = FutureProvider<List<LoginUserOption>>((ref) {
  ref.watch(_authRefreshKeyProvider);
  return ref.watch(authServiceProvider).listLoginUsers();
});

final isAdministratorProvider = Provider<bool>((ref) {
  final session = ref.watch(activeSessionProvider).valueOrNull;
  return session?.roleCode == 'administrator';
});

class AuthService {
  AuthService(this._db);

  final AppDatabase _db;

  Future<List<LoginUserOption>> listLoginUsers() async {
    final users =
        await (_db.select(_db.users)
              ..where(
                (tbl) =>
                    tbl.isDeleted.equals(false) & tbl.isActive.equals(true),
              )
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]))
            .get();
    final roles = await _db.select(_db.roles).get();
    final rolesById = {for (final role in roles) role.id: role};

    return users
        .map(
          (user) => LoginUserOption(
            userId: user.id,
            fullName: user.fullName,
            shortName: user.shortName,
            roleCode: rolesById[user.roleId]?.code ?? 'viewer',
            roleName: rolesById[user.roleId]?.name ?? 'Наблюдатель',
            requiresPin: (user.pinHash ?? '').isNotEmpty,
          ),
        )
        .toList(growable: false);
  }

  Future<AuthSession?> currentSession() async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((tbl) => tbl.key.equals('active_user_id'))).getSingleOrNull();
    final userId = nullableField(row?.valueJson);
    if (userId == null) {
      return null;
    }

    return _loadSession(userId);
  }

  Future<void> login({required String userId, String? pin}) async {
    final session = await _loadSession(userId);
    if (session == null) {
      throw StateError('Выбранный пользователь недоступен.');
    }

    final user = await (_db.select(
      _db.users,
    )..where((tbl) => tbl.id.equals(userId))).getSingle();
    final storedPinHash = nullableField(user.pinHash);
    if (storedPinHash != null && storedPinHash != pinHash(pin ?? '')) {
      await recordAudit(
        _db,
        actionType: 'login',
        resultStatus: 'error',
        userId: userId,
        entityType: 'user',
        entityId: userId,
        message: 'Введён неверный PIN-код',
      );
      throw StateError('Неверный PIN-код.');
    }

    final now = nowIso();
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userId))).write(
      UsersCompanion(lastLoginAt: driftValue(now), updatedAt: driftValue(now)),
    );
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: 'active_user_id',
            valueJson: userId,
            updatedAt: now,
          ),
        );

    await recordAudit(
      _db,
      actionType: 'login',
      resultStatus: 'success',
      userId: userId,
      entityType: 'user',
      entityId: userId,
      message: 'Локальный вход выполнен',
    );
  }

  Future<void> logout() async {
    final session = await currentSession();
    await (_db.delete(
      _db.appSettings,
    )..where((tbl) => tbl.key.equals('active_user_id'))).go();

    await recordAudit(
      _db,
      actionType: 'logout',
      resultStatus: 'success',
      userId: session?.userId,
      entityType: 'user',
      entityId: session?.userId,
      message: 'Локальная сессия завершена',
    );
  }

  Future<AuthSession?> _loadSession(String userId) async {
    final user =
        await (_db.select(_db.users)..where(
              (tbl) =>
                  tbl.id.equals(userId) &
                  tbl.isDeleted.equals(false) &
                  tbl.isActive.equals(true),
            ))
            .getSingleOrNull();
    if (user == null) {
      return null;
    }

    final role = await (_db.select(
      _db.roles,
    )..where((tbl) => tbl.id.equals(user.roleId))).getSingleOrNull();
    if (role == null) {
      return null;
    }

    return AuthSession(
      userId: user.id,
      fullName: user.fullName,
      roleId: role.id,
      roleCode: role.code,
      roleName: role.name,
    );
  }
}

void refreshAuthProviders(WidgetRef ref) {
  ref.read(_authRefreshKeyProvider.notifier).state++;
}
