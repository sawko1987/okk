import 'package:flutter_test/flutter_test.dart';
import 'package:okk_qc_app/core/auth/app_permissions.dart';

void main() {
  test('administrator has access to admin capabilities', () {
    expect(
      roleHasCapability('administrator', AppCapability.manageCatalog),
      isTrue,
    );
    expect(
      roleHasCapability('administrator', AppCapability.manageSyncSettings),
      isTrue,
    );
  });

  test('worker can inspect and sync but cannot manage catalog', () {
    expect(roleHasCapability('worker', AppCapability.startInspection), isTrue);
    expect(
      roleHasCapability('worker', AppCapability.completeInspection),
      isTrue,
    );
    expect(roleHasCapability('worker', AppCapability.runSync), isTrue);
    expect(roleHasCapability('worker', AppCapability.manageCatalog), isFalse);
  });

  test('viewer is limited to read access and device sync', () {
    expect(roleHasCapability('viewer', AppCapability.viewResults), isTrue);
    expect(roleHasCapability('viewer', AppCapability.runSync), isTrue);
    expect(roleHasCapability('viewer', AppCapability.startInspection), isFalse);
    expect(roleHasCapability('viewer', AppCapability.manageUsers), isFalse);
  });

  test('commission role adds signing capability on top of inspection flow', () {
    expect(
      roleHasCapability('commission', AppCapability.startInspection),
      isTrue,
    );
    expect(
      roleHasCapability('commission', AppCapability.completeInspection),
      isTrue,
    );
    expect(
      roleHasCapability('commission', AppCapability.signInspection),
      isTrue,
    );
    expect(roleHasCapability('commission', AppCapability.manageUsers), isFalse);
  });

  test('role capability listing matches static access matrix', () {
    expect(
      capabilitiesForRole('viewer'),
      equals([AppCapability.runSync, AppCapability.viewResults]),
    );
    expect(
      capabilitiesForRole('administrator'),
      containsAll(AppCapability.values),
    );
  });
}
