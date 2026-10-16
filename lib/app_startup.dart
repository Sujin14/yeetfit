import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'background_task_dispatcher.dart';
import 'core/services/notification_service.dart';
import 'features/calls/presentation/providers/pending_call_provider.dart';
import 'features/challenges/presentation/providers/pending_challenge_provider.dart';
import 'features/chat/presentation/providers/chat_provider.dart';
import 'features/chat/presentation/providers/pending_chat_provider.dart';
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

class _AppStartupState extends ConsumerState<AppStartup> {
  String? _activeUserId;
  StreamSubscription<String>? _openedCallSubscription;
  StreamSubscription<ChatNotificationTap>? _openedChatSubscription;
  StreamSubscription<ChatNotificationTap>? _tappedLocalChatSubscription;
  StreamSubscription<ChallengeNotificationTap>? _openedChallengeSubscription;
  StreamSubscription<ChallengeNotificationTap>?
  _tappedLocalChallengeSubscription;

  @override
  void initState() {
    super.initState();
    ref.listenManual<AsyncValue<User?>>(authStateProvider, (_, next) {
      if (next.isLoading) return;
      _onUserChanged(next.value?.uid);
    }, fireImmediately: true);

    final notifications = ref.read(notificationServiceProvider);
    _openedCallSubscription = notifications.openedIncomingCalls.listen(
      (callId) => ref.read(pendingCallProvider.notifier).set(callId),
    );
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
    _restorePendingCall(notifications);
    _restorePendingChat(notifications);
    _restorePendingChallenge(notifications);
  }

  @override
  void dispose() {
    _openedCallSubscription?.cancel();
    _openedChatSubscription?.cancel();
    _tappedLocalChatSubscription?.cancel();
    _openedChallengeSubscription?.cancel();
    _tappedLocalChallengeSubscription?.cancel();
    super.dispose();
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

  Future<void> _restorePendingCall(NotificationService notifications) async {
    try {
      final callId = await notifications.takePendingIncomingCallId();
      if (callId != null && mounted) {
        ref.read(pendingCallProvider.notifier).set(callId);
      }
    } catch (error) {
      debugPrint('Restoring pending call failed: $error');
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
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
