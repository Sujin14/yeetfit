import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/call_participant.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_status.dart';
import '../../domain/entities/call_type.dart';
import '../models/call_session_model.dart';
import 'call_exception.dart';

/// Reads and writes `calls/{callId}`.
class CallDataSource {
  final FirebaseFirestore _firestore;

  CallDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _calls =>
      _firestore.collection('calls');

  Future<CallParticipant> getParticipant(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    final data = doc.data() ?? const {};
    return CallParticipant(
      id: userId,
      name: data['name'] as String? ?? 'Yeetfit user',
      photoUrl: data['profilePicture'] as String? ?? '',
    );
  }

  Future<CallSession> createCall({
    required CallParticipant caller,
    required CallParticipant receiver,
    required CallType type,
  }) async {
    final ref = _calls.doc();
    final channelId = 'yeetfit-call-${ref.id}';
    await ref.set(
      CallSessionModel.toCreateMap(
        caller: caller,
        receiver: receiver,
        channelId: channelId,
        type: type,
      ),
    );
    return CallSession(
      id: ref.id,
      caller: caller,
      receiver: receiver,
      channelId: channelId,
      type: type,
      status: CallStatus.ringing,
      createdAt: DateTime.now(),
    );
  }

  /// Moves the call to [next] only from one of [allowedFrom], so e.g. an
  /// answer racing the missed-call timeout can't revive a finished call.
  Future<void> transition(
    String callId, {
    required CallStatus next,
    required Set<CallStatus> allowedFrom,
  }) {
    final ref = _calls.doc(callId);
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) {
        throw const CallException('This call no longer exists.');
      }
      final current = CallSessionModel.fromSnapshot(snapshot).status;
      if (current == next) return;
      if (!allowedFrom.contains(current)) {
        throw const CallException('This call has already ended.');
      }
      transaction.update(ref, {
        'status': next.name,
        if (next == CallStatus.active)
          'startedAt': FieldValue.serverTimestamp(),
        if (next.isFinished) 'endedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Equality filters only, so no composite index is needed; the newest
  /// call is picked client-side.
  Stream<CallSession?> watchIncomingCall(String userId) {
    return _calls
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: CallStatus.ringing.name)
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();
          final calls =
              snapshot.docs
                  .map(CallSessionModel.fromSnapshot)
                  .where((call) => call.isRingingAt(now))
                  .toList()
                ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          return calls.firstOrNull;
        });
  }

  Future<CallSession?> getCall(String callId) async {
    final doc = await _calls.doc(callId).get();
    return doc.exists ? CallSessionModel.fromSnapshot(doc) : null;
  }

  Stream<CallSession?> watchCall(String callId) {
    return _calls
        .doc(callId)
        .snapshots()
        .map((doc) => doc.exists ? CallSessionModel.fromSnapshot(doc) : null);
  }
}
