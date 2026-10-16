import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/services/notification_service.dart';

/// A coach chat opened from a push notification, waiting for the signed-in
/// shell to present it.
final pendingChatProvider =
    NotifierProvider<PendingChatController, ChatNotificationTap?>(
      PendingChatController.new,
    );

class PendingChatController extends Notifier<ChatNotificationTap?> {
  @override
  ChatNotificationTap? build() => null;

  void set(ChatNotificationTap tap) => state = tap;

  void clear() => state = null;
}
