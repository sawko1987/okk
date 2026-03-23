import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/platform/app_platform.dart';
import '../../data/sync/sync_service.dart';
import '../../features/auth/data/auth_service.dart';

final syncLifecycleObserverProvider = Provider<SyncLifecycleObserver>((ref) {
  final observer = SyncLifecycleObserver(ref);
  WidgetsBinding.instance.addObserver(observer);
  ref.onDispose(() {
    WidgetsBinding.instance.removeObserver(observer);
    observer.dispose();
  });
  return observer;
});

class SyncLifecycleObserver extends WidgetsBindingObserver {
  SyncLifecycleObserver(this._ref);

  final Ref _ref;
  bool _resumeSyncInFlight = false;
  DateTime? _lastResumeSyncAt;
  Timer? _foregroundRetryTimer;

  void dispose() {
    _foregroundRetryTimer?.cancel();
    _foregroundRetryTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startForegroundRetryLoop();
      Future<void>.microtask(_runResumeSync);
      return;
    }
    _foregroundRetryTimer?.cancel();
    _foregroundRetryTimer = null;
  }

  Future<void> _runResumeSync() async {
    await _runAutomaticSync(trigger: 'resume');
  }

  void _startForegroundRetryLoop() {
    _foregroundRetryTimer?.cancel();
    _foregroundRetryTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      Future<void>.microtask(_runForegroundRetrySync);
    });
  }

  Future<void> _runForegroundRetrySync() async {
    final diagnostics = await _ref.read(syncServiceProvider).loadDiagnostics();
    final shouldRetry =
        diagnostics.transportConfigured &&
        (diagnostics.retryEligibleCount > 0 ||
            diagnostics.failedQueueCount > 0 ||
            diagnostics.pendingOutgoingCount > 0 ||
            diagnostics.pendingIncomingCount > 0);
    if (!shouldRetry) {
      return;
    }
    await _runAutomaticSync(trigger: 'foreground_poll');
  }

  Future<void> _runAutomaticSync({required String trigger}) async {
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
      await _ref
          .read(syncServiceProvider)
          .runAutomaticRetrySync(
            platform: platform,
            actorUserId: session.userId,
            trigger: trigger,
          );
    } finally {
      _resumeSyncInFlight = false;
    }
  }
}
