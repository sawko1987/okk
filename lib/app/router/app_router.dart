import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/app_entry_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/catalog/presentation/windows_admin_sections.dart';
import '../../features/catalog/presentation/windows_admin_shell.dart';
import '../../features/inspections/presentation/android_inspection_shell.dart';
import '../../features/inspections/presentation/android_workflow_screens.dart';
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
      GoRoute(
        path: '/android',
        builder: (context, state) => const AndroidModeScreen(),
      ),
      GoRoute(
        path: '/android/sync',
        builder: (context, state) => const AndroidSyncScreen(),
      ),
      GoRoute(
        path: '/android/workshops',
        builder: (context, state) => const AndroidWorkshopSelectionScreen(),
      ),
      GoRoute(
        path: '/android/workshops/:workshopId/products',
        builder: (context, state) => AndroidProductSelectionScreen(
          workshopId: state.pathParameters['workshopId']!,
        ),
      ),
      GoRoute(
        path: '/android/workshops/:workshopId/products/:productId/targets',
        builder: (context, state) => AndroidTargetSelectionScreen(
          workshopId: state.pathParameters['workshopId']!,
          productId: state.pathParameters['productId']!,
        ),
      ),
      GoRoute(
        path:
            '/android/workshops/:workshopId/products/:productId/targets/:targetId/components',
        builder: (context, state) => AndroidComponentsScreen(
          workshopId: state.pathParameters['workshopId']!,
          productId: state.pathParameters['productId']!,
          targetId: state.pathParameters['targetId']!,
        ),
      ),
      GoRoute(
        path:
            '/android/workshops/:workshopId/products/:productId/targets/:targetId/components/:componentId',
        builder: (context, state) => AndroidComponentDetailsScreen(
          componentId: state.pathParameters['componentId']!,
        ),
      ),
      GoRoute(
        path: '/android/drafts',
        builder: (context, state) => const AndroidDraftsScreen(),
      ),
      GoRoute(
        path: '/android/results',
        builder: (context, state) => const AndroidResultsScreen(),
      ),
      GoRoute(
        path: '/android/inspections/:inspectionId',
        builder: (context, state) => AndroidInspectionDetailScreen(
          inspectionId: state.pathParameters['inspectionId']!,
        ),
      ),
      GoRoute(
        path: '/android/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/android/diagnostics',
        builder: (context, state) => const SyncDiagnosticsScreen(),
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
