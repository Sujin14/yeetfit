import '../../domain/entities/client_profile.dart';
import '../../domain/entities/coach.dart';
import '../../domain/repositories/coach_repository.dart';
import '../datasources/coach_datasource.dart';

class CoachRepositoryImpl implements CoachRepository {
  final CoachDataSource _dataSource;

  CoachRepositoryImpl({required CoachDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Stream<List<Coach>> watchActiveCoaches() => _dataSource.watchActiveCoaches();

  @override
  Future<Coach?> getCoach(String coachId) => _dataSource.getCoach(coachId);

  @override
  Stream<ClientProfile> watchClientProfile(String clientUid) =>
      _dataSource.watchClientProfile(clientUid);

  @override
  Stream<String?> watchCurrentCoachId(String clientUid) =>
      _dataSource.watchCurrentCoachId(clientUid);

  @override
  Stream<bool> watchHasPendingRequest({
    required String clientUid,
    required String coachId,
  }) => _dataSource.watchHasPendingRequest(
    clientUid: clientUid,
    coachId: coachId,
  );

  @override
  Future<void> requestCoach({
    required String clientUid,
    required String coachId,
  }) => _dataSource.requestCoach(clientUid: clientUid, coachId: coachId);

  @override
  Future<void> removeCoach() => _dataSource.removeCoach();
}
