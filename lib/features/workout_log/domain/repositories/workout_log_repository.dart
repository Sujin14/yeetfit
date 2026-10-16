import '../entities/workout_log.dart';

abstract class WorkoutLogRepository {
  /// The log for [date] (`yyyy-MM-dd`), or null when nothing is logged.
  Stream<WorkoutLog?> watchLog(String userId, String date);

  /// Writes [log] for its date, replacing any earlier log that day.
  Future<void> saveLog(String userId, WorkoutLog log);
}
