import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/platform/app_platform.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/catalog/presentation/windows_admin_shell.dart';
import '../../features/inspections/presentation/android_inspection_shell.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/sync/presentation/sync_diagnostics_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          final appPlatform = getAppPlatform();

          if (appPlatform == AppPlatform.windows) {
            return const WindowsAdminShell();
          }

          return const AndroidInspectionShell();
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/diagnostics',
        builder: (context, state) => const SyncDiagnosticsScreen(),
      ),
    ],
  );
});
