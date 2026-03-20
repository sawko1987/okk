import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/platform/app_platform.dart';
import '../../data/sync/sync_service.dart';
import '../../features/auth/data/auth_service.dart';

final syncLifecycleObserverProvider = Provider<SyncLifecycleObserver>((ref) {
  final observer = SyncLifecycleObserver(ref);
  WidgetsBinding.instance.addObserver(observer);
  ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
  return observer;
});

class SyncLifecycleObserver extends WidgetsBindingObserver {
  SyncLifecycleObserver(this._ref);

  final Ref _ref;
  bool _resumeSyncInFlight = false;
  DateTime? _lastResumeSyncAt;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }
    Future<void>.microtask(_runResumeSync);
  }

  Future<void> _runResumeSync() async {
    if (_resumeSyncInFlight) {
      return;
    }
    final lastResumeSyncAt = _lastResumeSyncAt;
    final now = DateTime.now().toUtc();
    if (lastResumeSyncAt != null &&
        now.difference(lastResumeSyncAt) < const Duration(seconds: 30)) {
      return;
    }

    final session = await _ref.read(authServiceProvider).currentSession();
    if (session == null) {
      return;
    }

    final platform = getAppPlatform();
    if (platform == AppPlatform.unsupported) {
      return;
    }

    _resumeSyncInFlight = true;
    _lastResumeSyncAt = now;
    try {
      await _ref.read(syncServiceProvider).syncOnResume(
            platform: platform,
            actorUserId: session.userId,
          );
    } finally {
      _resumeSyncInFlight = false;
    }
  }
}
