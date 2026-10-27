import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'background_task_dispatcher.dart';
import 'core/constants/notification_constants.dart';
import 'core/providers/call_launch_providers.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/call_route_constants.dart';
import 'core/routes/shell_route_constants.dart';
import 'core/services/call_native_service.dart';
import 'core/services/notification_service.dart';
import 'features/calls/domain/entities/call_status.dart';
import 'features/calls/presentation/providers/call_provider.dart';
import 'features/challenges/presentation/providers/pending_challenge_provider.dart';
import 'features/chat/presentation/providers/chat_provider.dart';
import 'features/chat/presentation/providers/pending_chat_provider.dart';
import 'features/coaches/presentation/providers/coach_provider.dart';
import 'shared/providers/auth_providers.dart';

/// Runs provider-dependent startup work inside the app's [ProviderScope].
///
/// Initialisation runs in the background so the first frame (splash) is not
/// blocked by permission prompts or network calls.
class AppStartup extends ConsumerStatefulWidget {
  const AppStartup({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends ConsumerState<AppStartup>
    with WidgetsBindingObserver {
  String? _activeUserId;
  StreamSubscription<RemoteMessage>? _fcmMessageSubscription;
  /// Firestore watchers started on foreground incoming_call FCM (coach hangup).
  final Map<String, StreamSubscription<dynamic>> _remoteHangupSubscriptions =
      {};
  final Set<String> _endedCallIds = {};
  final Set<String> _acceptedCallIds = {};
  /// Once per process — call-setup prompt after landing on the shell.
  bool _callSetupPromptedThisLaunch = false;
  StreamSubscription<ChatNotificationTap>? _openedChatSubscription;
  StreamSubscription<ChatNotificationTap>? _tappedLocalChatSubscription;
  StreamSubscription<ChallengeNotificationTap>? _openedChallengeSubscription;
  StreamSubscription<ChallengeNotificationTap>?
  _tappedLocalChallengeSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.listenManual<AsyncValue<User?>>(authStateProvider, (_, next) {
      if (next.isLoading) return;
      _onUserChanged(next.value?.uid);
    }, fireImmediately: true);

    final notifications = ref.read(notificationServiceProvider);
    CallNativeService.setOnCallAccepted((callId) => _acceptIncomingCall(callId));
    // Native owns the ringing UI; Dart only watches Firestore for coach hangup.
    _fcmMessageSubscription = FirebaseMessaging.onMessage.listen((message) {
      if (message.data['type'] != NotificationConstants.typeIncomingCall) {
        return;
      }
      final callId = message.data['callId'];
      if (callId == null || callId.isEmpty) return;
      debugPrint(
        '[YeetCall] FCM foreground: starting hangup watcher for $callId',
      );
      unawaited(_startRemoteHangupWatcher(callId));
    });
    unawaited(_openAcceptedCallFromLockScreen());
    _openedChatSubscription = notifications.openedChatMessages.listen(
      (tap) => ref.read(pendingChatProvider.notifier).set(tap),
    );
    _tappedLocalChatSubscription = notifications.tappedLocalChatMessages.listen(
      (tap) => ref.read(pendingChatProvider.notifier).set(tap),
    );
    _openedChallengeSubscription = notifications.openedChallengeAssignments
        .listen((tap) => ref.read(pendingChallengeProvider.notifier).set(tap));
    _tappedLocalChallengeSubscription = notifications
        .tappedLocalChallengeAssignments
        .listen((tap) => ref.read(pendingChallengeProvider.notifier).set(tap));
    _restorePendingChat(notifications);
    _restorePendingChallenge(notifications);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fcmMessageSubscription?.cancel();
    for (final sub in _remoteHangupSubscriptions.values) {
      unawaited(sub.cancel());
    }
    _remoteHangupSubscriptions.clear();
    _openedChatSubscription?.cancel();
    _tappedLocalChatSubscription?.cancel();
    _openedChallengeSubscription?.cancel();
    _tappedLocalChallengeSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    unawaited(_openAcceptedCallFromLockScreen());
  }

  /// Dismisses the native call UI when the coach hangs up before accept.
  Future<void> _startRemoteHangupWatcher(String callId) async {
    if (callId.isEmpty) return;
    await _stopWatchingRemoteHangup(callId);
    _remoteHangupSubscriptions[callId] = ref
        .read(callRepositoryProvider)
        .watchCall(callId)
        .listen((call) async {
          final statusName = call?.status.name;
          debugPrint('[YeetCall] Call status changed: $statusName');
          if (statusName != 'cancelled' &&
              statusName != 'ended' &&
              statusName != 'missed' &&
              statusName != CallStatus.declined.name) {
            return;
          }
          _endedCallIds.add(callId);
          debugPrint('[YeetCall] Marked $callId as ended in _endedCallIds');
          debugPrint(
            '[YeetCall] Coach cancelled before accept — dismissing native UI for $callId',
          );
          await CallNativeService.dismissIncomingCall(callId);
          await _stopWatchingRemoteHangup(callId);
        });
  }

  Future<void> _stopWatchingRemoteHangup(String callId) async {
    final sub = _remoteHangupSubscriptions.remove(callId);
    await sub?.cancel();
  }

  bool _isOnMainShell() {
    final path = appRouter.state.uri.path;
    return path == ShellRouteConstants.dashboard ||
        path == ShellRouteConstants.explore ||
        path == ShellRouteConstants.progress ||
        path == ShellRouteConstants.coaches;
  }

  /// After sign-in + shell, once per launch: open call setup if incomplete or
  /// core readiness fails. Gated on [currentCoachIdProvider] (client has a coach).
  Future<void> _maybePromptCallSetup(String userId) async {
    if (_callSetupPromptedThisLaunch) return;
    if (kIsWeb || !Platform.isAndroid) return;

    for (var i = 0; i < 40; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      if (!mounted || _activeUserId != userId) return;
      if (_isOnMainShell()) break;
      if (i == 39) {
        debugPrint('[YeetCall] Call setup prompt skipped — never reached shell');
        return;
      }
    }

    if (_callSetupPromptedThisLaunch) return;

    try {
      final coachId = await ref.read(currentCoachIdProvider(userId).future);
      if (coachId == null || coachId.isEmpty) {
        debugPrint(
          '[YeetCall] Call setup prompt skipped — no assigned coach',
        );
        return;
      }
    } catch (e) {
      debugPrint('[YeetCall] Call setup coach check failed: $e');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final completed =
        prefs.getBool(CallNativeService.prefsCallSetupCompleted) ?? false;
    final readiness = await CallNativeService.getCallReadiness();
    final coreOk = readiness?.coreOk ?? false;
    if (completed && coreOk) {
      debugPrint('[YeetCall] Call setup prompt skipped — already ready');
      return;
    }

    if (!mounted || _activeUserId != userId || !_isOnMainShell()) return;
    _callSetupPromptedThisLaunch = true;
    debugPrint(
      '[YeetCall] Opening call setup (completed=$completed coreOk=$coreOk)',
    );
    appRouter.push(CallRouteConstants.callSetup);
  }

  /// Warm-path accept may arrive before [setOnCallAccepted] is registered.
  /// Cold starts are handled by splash → /joining-call when
  /// [pendingAcceptedCallIdProvider] is set from [main].
  Future<void> _openAcceptedCallFromLockScreen() async {
    final pendingFromLaunch = ref.read(pendingAcceptedCallIdProvider);
    if (pendingFromLaunch != null && pendingFromLaunch.isNotEmpty) return;

    try {
      final callId = await CallNativeService.consumePendingAcceptedCall();
      if (callId == null || callId.isEmpty) return;
      await _acceptIncomingCall(callId);
    } catch (e) {
      debugPrint('_openAcceptedCallFromLockScreen error: $e');
    }
  }

  Future<void> _acceptIncomingCall(String callId) async {
    debugPrint('[YeetCall] _acceptIncomingCall: $callId');
    if (callId.startsWith('test_')) {
      debugPrint('[YeetCall] Test call accepted — marking setup test passed');
      await CallNativeService.clearLockScreenFlags();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(CallNativeService.prefsCallSetupTestPassed, true);
      if (!mounted) return;
      appRouter.go(CallRouteConstants.callSetup);
      return;
    }
    if (_endedCallIds.contains(callId)) {
      debugPrint(
        '[YeetCall] _acceptIncomingCall: $callId already ended — ignoring stale Accept',
      );
      await CallNativeService.dismissIncomingCall(callId);
      await CallNativeService.clearLockScreenFlags();
      return;
    }
    if (callId.isEmpty || !mounted || !_acceptedCallIds.add(callId)) return;
    final repository = ref.read(callRepositoryProvider);
    try {
      await repository.acceptCall(callId);
    } catch (error) {
      debugPrint('Accepting the call failed: $error');
    }
    if (!mounted) return;
    final call = await repository.getCall(callId);
    if (!mounted || call == null) {
      _acceptedCallIds.remove(callId);
      return;
    }
    debugPrint('[YeetCall] Navigating to active call');
    appRouter.push(CallRouteConstants.activeCallPath(call.id), extra: call);
  }

  Future<void> _restorePendingChallenge(
    NotificationService notifications,
  ) async {
    try {
      final tap = await notifications.takePendingChallengeNotification();
      if (tap != null && mounted) {
        ref.read(pendingChallengeProvider.notifier).set(tap);
      }
    } catch (error) {
      debugPrint('Restoring pending challenge failed: $error');
    }
  }

  Future<void> _restorePendingChat(NotificationService notifications) async {
    try {
      final tap = await notifications.takePendingChatNotification();
      if (tap != null && mounted) {
        ref.read(pendingChatProvider.notifier).set(tap);
      }
    } catch (error) {
      debugPrint('Restoring pending chat failed: $error');
    }
  }

  Future<void> _onUserChanged(String? userId) async {
    if (userId == _activeUserId) return;
    _activeUserId = userId;

    final messageDelivery = ref.read(messageDeliveryServiceProvider);
    final notifications = ref.read(notificationServiceProvider);

    if (userId == null) {
      messageDelivery.stop();
      await notifications.stopUserSession();
      return;
    }

    messageDelivery.start(userId);
    try {
      await notifications.init(userId);
    } catch (error, stackTrace) {
      debugPrint('Notification startup failed: $error\n$stackTrace');
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await cancelLegacyStepsTasks(userId);
      } catch (error) {
        debugPrint('Cancelling legacy steps tasks failed: $error');
      }
    }
    unawaited(_maybePromptCallSetup(userId));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
