import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'sync/sync_lifecycle_scope.dart';
import 'theme/app_theme.dart';

class OkkQcApp extends ConsumerWidget {
  const OkkQcApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncLifecycleObserverProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Контроль качества ОКК',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
    );
  }
}
