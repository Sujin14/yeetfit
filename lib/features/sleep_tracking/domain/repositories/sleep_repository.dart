import '../entities/sleep_data.dart';

// Abstract repository for sleep tracking operations.
abstract class SleepRepository {
  // Streams today's sleep entry; `null` until one is saved.
  Stream<SleepData?> watchTodaySleep(String userId);

  // Adds sleep entry.
  Future<void> addSleepEntry(
    String userId,
    DateTime bedtime,
    DateTime wakeUpTime,
    double duration,
  );

  // Sets sleep goal.
  Future<void> setSleepGoal(String userId, double newGoal);

  // Fetches weekly sleep data.
  Future<List<SleepData>> getWeeklySleepData(String userId);
}
