import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A call opened from a push notification, waiting for the signed-in shell
/// to present it.
final pendingCallProvider = NotifierProvider<PendingCallController, String?>(
  PendingCallController.new,
);

class PendingCallController extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String callId) => state = callId;

  void clear() => state = null;
}
