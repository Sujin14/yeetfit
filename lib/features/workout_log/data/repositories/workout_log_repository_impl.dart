import '../../domain/entities/workout_log.dart';
import '../../domain/repositories/workout_log_repository.dart';
import '../datasources/workout_log_datasource.dart';

class WorkoutLogRepositoryImpl implements WorkoutLogRepository {
  final WorkoutLogDataSource _dataSource;

  WorkoutLogRepositoryImpl(this._dataSource);

  @override
  Stream<WorkoutLog?> watchLog(String userId, String date) =>
      _dataSource.watchLog(userId, date);

  @override
  Future<void> saveLog(String userId, WorkoutLog log) =>
      _dataSource.saveLog(userId, log);
}
