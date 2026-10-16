import 'call_participant.dart';
import 'call_status.dart';
import 'call_type.dart';

/// A 1-to-1 call between a user and their coach (`calls/{id}`).
class CallSession {
  /// A call still "ringing" after this long was abandoned (the caller's app
  /// was killed before it could mark the call missed).
  static const Duration abandonedRingingAge = Duration(seconds: 60);

  final String id;
  final CallParticipant caller;
  final CallParticipant receiver;

  /// Realtime channel both parties join.
  final String channelId;
  final CallType type;
  final CallStatus status;

  /// Null until the server timestamp of a freshly created call resolves.
  final DateTime? createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;

  const CallSession({
    required this.id,
    required this.caller,
    required this.receiver,
    required this.channelId,
    required this.type,
    required this.status,
    this.createdAt,
    this.startedAt,
    this.endedAt,
  });

  bool isCaller(String userId) => caller.id == userId;

  /// Ringing and recent enough that the caller is still waiting.
  bool isRingingAt(DateTime now) {
    final createdAt = this.createdAt;
    return status == CallStatus.ringing &&
        createdAt != null &&
        now.difference(createdAt) < abandonedRingingAge;
  }

  CallParticipant otherParty(String userId) =>
      isCaller(userId) ? receiver : caller;
}
