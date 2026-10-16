import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/services/notification_service.dart';

/// A challenge assignment opened from a push notification, waiting for the
/// signed-in shell to present it.
final pendingChallengeProvider =
    NotifierProvider<PendingChallengeController, ChallengeNotificationTap?>(
      PendingChallengeController.new,
    );

class PendingChallengeController extends Notifier<ChallengeNotificationTap?> {
  @override
  ChallengeNotificationTap? build() => null;

  void set(ChallengeNotificationTap tap) => state = tap;

  void clear() => state = null;
}
