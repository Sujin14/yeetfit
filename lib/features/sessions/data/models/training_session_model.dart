import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/new_training_session.dart';
import '../../domain/entities/training_session.dart';

/// Firestore mapping for `sessions/{sessionId}`.
class TrainingSessionModel {
  const TrainingSessionModel._();

  static TrainingSession fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? const {};
    return TrainingSession(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      trainerId: data['trainerId'] as String? ?? '',
      trainerName: data['trainerName'] as String? ?? 'Coach',
      trainerPhoto: data['trainerPhoto'] as String? ?? '',
      meetLink: data['meetLink'] as String? ?? '',
      scheduledAt:
          (data['scheduledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      durationMinutes: (data['durationMinutes'] as num?)?.toInt() ?? 60,
      isGlobal: data['isGlobal'] as bool? ?? false,
      assignedClientUids: List<String>.from(
        data['assignedClientUids'] ?? const [],
      ),
    );
  }

  static Map<String, dynamic> toCreateMap({
    required NewTrainingSession session,
    required String trainerId,
    required String trainerName,
    required String trainerPhoto,
  }) {
    final endsAt = session.scheduledAt.add(
      Duration(minutes: session.durationMinutes),
    );
    return {
      'title': session.title,
      'description': session.description,
      'trainerId': trainerId,
      'trainerName': trainerName,
      'trainerPhoto': trainerPhoto,
      'meetLink': session.meetLink,
      'scheduledAt': Timestamp.fromDate(session.scheduledAt),
      // Stored so a single range filter finds live and upcoming sessions.
      'endsAt': Timestamp.fromDate(endsAt),
      'durationMinutes': session.durationMinutes,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
