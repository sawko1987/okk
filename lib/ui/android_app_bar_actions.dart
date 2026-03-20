import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/data/auth_service.dart';
import '../features/inspections/presentation/android_routes.dart';

List<Widget> buildAndroidAppBarActions({
  required BuildContext context,
  required WidgetRef ref,
  required AuthSession session,
}) {
  final currentPath = GoRouterState.of(context).uri.path;

  return [
    if (currentPath != AndroidRoutes.home)
      IconButton(
        onPressed: () => context.go(AndroidRoutes.home),
        icon: const Icon(Icons.home_outlined),
        tooltip: 'Рабочее место',
      ),
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(session.fullName),
      ),
    ),
    IconButton(
      onPressed: currentPath == AndroidRoutes.diagnostics
          ? null
          : () => context.push(AndroidRoutes.diagnostics),
      icon: const Icon(Icons.monitor_heart_outlined),
      tooltip: 'Диагностика',
    ),
    IconButton(
      onPressed: currentPath == AndroidRoutes.settings
          ? null
          : () => context.push(AndroidRoutes.settings),
      icon: const Icon(Icons.settings_outlined),
      tooltip: 'Настройки',
    ),
    IconButton(
      onPressed: () async {
        await ref.read(authServiceProvider).logout();
        refreshAuthProviders(ref);
        if (!context.mounted) {
          return;
        }
        context.go('/');
      },
      icon: const Icon(Icons.logout_outlined),
      tooltip: 'Выход',
    ),
  ];
}
