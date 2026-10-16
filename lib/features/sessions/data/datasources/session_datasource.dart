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

  /// Range filter and order on the same field, so no composite index is
  /// needed. Sessions that end while the stream is open are dropped by
  /// callers comparing against the clock.
  Stream<List<TrainingSession>> watchUpcomingSessions() {
    return _sessions
        .where('endsAt', isGreaterThan: Timestamp.now())
        .orderBy('endsAt')
        .limit(_maxSessions)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(TrainingSessionModel.fromSnapshot).toList()
                ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt)),
        );
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
