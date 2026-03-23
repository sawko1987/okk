import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/platform/app_platform.dart';
import '../../../core/utils/user_message.dart';
import '../../catalog/presentation/windows_admin_sections.dart';
import '../../catalog/presentation/windows_admin_shell.dart';
import '../../inspections/presentation/android_workflow_screens.dart';
import '../data/auth_service.dart';
import 'login_screen.dart';

class AppEntryScreen extends ConsumerWidget {
  const AppEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platform = getAppPlatform();
    final sessionAsync = ref.watch(activeSessionProvider);
    return sessionAsync.when(
      data: (session) {
        if (session == null) {
          return const LoginScreen();
        }

        return switch (platform) {
          AppPlatform.android => const AndroidModeScreen(),
          AppPlatform.windows => const WindowsAdminShell(
              section: WindowsAdminSection.dashboard,
            ),
          AppPlatform.unsupported => const Scaffold(
              body: Center(child: Text('Платформа не поддерживается.')),
            ),
        };
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(
          child: Text(
            'Не удалось инициализировать сессию. ${userMessageFromError(error, fallback: 'Повторите запуск приложения.')}',
          ),
        ),
      ),
    );
  }
}
