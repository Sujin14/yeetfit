import '../../data/model/sleep_model.dart';

// Abstract repository for sleep tracking operations.
abstract class SleepRepository {
  // Fetches today's sleep data.
  Future<SleepData?> getSleepData(String userId);

  // Fetches today's sleep goal.
  Future<double> getSleepGoal(String userId);

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