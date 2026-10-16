import '../entities/call_participant.dart';
import '../entities/call_session.dart';
import '../entities/call_type.dart';

abstract class CallRepository {
  /// Profile shown to the other party (name and photo from `users/{id}`).
  Future<CallParticipant> getParticipant(String userId);

  /// Creates a ringing call from [caller] to [receiver].
  Future<CallSession> initiateCall({
    required CallParticipant caller,
    required CallParticipant receiver,
    required CallType type,
  });

  Future<void> acceptCall(String callId);

  Future<void> declineCall(String callId);

  Future<void> endCall(String callId);

  /// Ringing timed out without an answer.
  Future<void> markMissed(String callId);

  /// The newest call ringing for [userId], or null.
  Stream<CallSession?> watchIncomingCall(String userId);

  Stream<CallSession?> watchCall(String callId);

  /// One-off read, e.g. for a call opened from a push notification.
  Future<CallSession?> getCall(String callId);

  /// Realtime messaging API key, fetched from the `getCallConfig` function.
  Future<String> getRealtimeApiKey();
}
