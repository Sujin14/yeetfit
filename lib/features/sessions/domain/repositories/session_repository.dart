import '../entities/new_training_session.dart';
import '../entities/training_session.dart';

abstract class SessionRepository {
  /// Live and upcoming sessions, soonest first.
  /// [coachId] limits the stream to that trainer.
  Stream<List<TrainingSession>> watchUpcomingSessions({
    String? coachId,
    String? currentUserId,
  });

  /// Returns the new session's id.
  Future<String> createSession({
    required String trainerId,
    required NewTrainingSession session,
  });

  Future<void> deleteSession(String sessionId);
}
