import '../../domain/entities/new_training_session.dart';
import '../../domain/entities/training_session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_datasource.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionDataSource _dataSource;

  const SessionRepositoryImpl(this._dataSource);

  @override
  Stream<List<TrainingSession>> watchUpcomingSessions({
    String? coachId,
    String? currentUserId,
  }) => _dataSource.watchUpcomingSessions(
    coachId: coachId,
    currentUserId: currentUserId,
  );

  @override
  Future<String> createSession({
    required String trainerId,
    required NewTrainingSession session,
  }) => _dataSource.createSession(trainerId: trainerId, session: session);

  @override
  Future<void> deleteSession(String sessionId) =>
      _dataSource.deleteSession(sessionId);
}
