import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/call_participant.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_status.dart';
import '../../domain/entities/call_type.dart';

/// Firestore mapping for `calls/{callId}`.
class CallSessionModel {
  const CallSessionModel._();

  static CallSession fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return CallSession(
      id: doc.id,
      caller: CallParticipant(
        id: data['callerId'] as String? ?? '',
        name: data['callerName'] as String? ?? 'Unknown',
        photoUrl: data['callerPhoto'] as String? ?? '',
      ),
      receiver: CallParticipant(
        id: data['receiverId'] as String? ?? '',
        name: data['receiverName'] as String? ?? 'Coach',
        photoUrl: data['receiverPhoto'] as String? ?? '',
      ),
      channelId: data['channelId'] as String? ?? '',
      type: CallType.values.asNameMap()[data['type']] ?? CallType.audio,
      status: CallStatus.values.asNameMap()[data['status']] ?? CallStatus.ended,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      startedAt: (data['startedAt'] as Timestamp?)?.toDate(),
      endedAt: (data['endedAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> toCreateMap({
    required CallParticipant caller,
    required CallParticipant receiver,
    required String channelId,
    required CallType type,
  }) {
    return {
      'callerId': caller.id,
      'callerName': caller.name,
      'callerPhoto': caller.photoUrl,
      'receiverId': receiver.id,
      'receiverName': receiver.name,
      'receiverPhoto': receiver.photoUrl,
      'channelId': channelId,
      'type': type.name,
      'status': CallStatus.ringing.name,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
