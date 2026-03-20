import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/data/sqlite/app_database.dart';
import 'package:okk_qc_app/features/admin/data/admin_repositories.dart';

void main() {
  late AppDatabase database;
  late UsersRepository usersRepository;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.ensureBootstrapData(
      deviceId: 'test-device',
      deviceName: 'test-host',
      platform: 'windows',
      appVersion: '1.0.0+1',
      rootPath: 'D:/OKK/test_app_data',
    );
    usersRepository = UsersRepository(database);

    final now = DateTime.now().toUtc().toIso8601String();
    await database.into(database.users).insert(
      UsersCompanion.insert(
        id: 'user-worker',
        fullName: 'Worker User',
        shortName: const Value('Worker'),
        roleId: 'role-worker',
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('worker cannot create users through admin repository', () async {
    await expectLater(
      () => usersRepository.saveUser(
        fullName: 'Blocked User',
        roleId: 'role-viewer',
        isActive: true,
        actorUserId: 'user-worker',
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          'Only administrators can manage users.',
        ),
      ),
    );
  });

  test('administrator can create users through admin repository', () async {
    await usersRepository.saveUser(
      fullName: 'Viewer User',
      roleId: 'role-viewer',
      isActive: true,
      actorUserId: 'user-default-admin',
    );

    final users = await usersRepository.listUsers();
    expect(
      users.map((entry) => entry.user.fullName),
      contains('Viewer User'),
    );
  });
}
