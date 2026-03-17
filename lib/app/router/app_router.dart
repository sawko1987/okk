import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/app_entry_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/catalog/presentation/windows_admin_sections.dart';
import '../../features/catalog/presentation/windows_admin_shell.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/sync/presentation/sync_diagnostics_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AppEntryScreen(),
      ),
      GoRoute(
        path: '/windows',
        builder: (context, state) => const WindowsAdminShell(
          section: WindowsAdminSection.dashboard,
        ),
      ),
      GoRoute(
        path: '/windows/:section',
        builder: (context, state) => WindowsAdminShell(
          section: sectionFromPath(state.pathParameters['section']),
        ),
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
