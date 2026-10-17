import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/new_training_session.dart';
import '../../domain/entities/training_session.dart';
import '../models/training_session_model.dart';

/// Reads and writes `sessions/{sessionId}`.
class SessionDataSource {
  static const int _maxSessions = 20;

  final FirebaseFirestore _firestore;

  SessionDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _sessions =>
      _firestore.collection('sessions');

  /// Live and upcoming sessions. [coachId] limits the stream to one trainer.
  /// Sessions that end while the stream is open are dropped by callers
  /// comparing against the clock.
  Stream<List<TrainingSession>> watchUpcomingSessions({
    String? coachId,
    String? currentUserId,
  }) {
    var query = _sessions.where('endsAt', isGreaterThan: Timestamp.now());

    if (coachId != null) {
      query = query.where('trainerId', isEqualTo: coachId);
    }

    return query
        .orderBy('endsAt')
        .limit(_maxSessions)
        .snapshots()
        .map((snapshot) {
          final all = snapshot.docs
              .map(TrainingSessionModel.fromSnapshot)
              .toList();

          // Global sessions, or ones this client was explicitly assigned to.
          final filtered = currentUserId == null
              ? all
              : all
                    .where(
                      (session) =>
                          session.isGlobal == true ||
                          session.assignedClientUids.contains(currentUserId),
                    )
                    .toList();

          return filtered
            ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        });
  }

  Future<String> createSession({
    required String trainerId,
    required NewTrainingSession session,
  }) async {
    final trainer = await _firestore.collection('users').doc(trainerId).get();
    final ref = await _sessions.add(
      TrainingSessionModel.toCreateMap(
        session: session,
        trainerId: trainerId,
        trainerName: trainer.data()?['name'] as String? ?? 'Coach',
        trainerPhoto: trainer.data()?['profilePicture'] as String? ?? '',
      ),
    );
    return ref.id;
  }

  Future<void> deleteSession(String sessionId) =>
      _sessions.doc(sessionId).delete();
}
