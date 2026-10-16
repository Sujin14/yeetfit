import '../entities/steps_data.dart';

// Abstract repository for steps tracking operations.
abstract class StepsRepository {
  // Fetches steps goal for a date.
  Future<int> getStepsGoal(String userId, String date);

  // Sets steps goal for today.
  Future<void> setStepsGoal(String userId, int newGoal);

  // Fetches the last seven days of saved steps.
  Future<List<StepsData>> getWeeklyStepsData(String userId);

  // Syncs entries saved offline to Firestore.
  Future<void> syncLocalData(String userId);

  // Saves the step count for a specific date.
  Future<void> updateDailySteps(String userId, String date, int steps);

  // Asks for health-store access, automatically only once per install.
  Future<void> requestHealthAccessOnce();

  // Asks for health-store access (user action).
  Future<void> requestHealthAccess();

  // Steps from the device health store, or null without access.
  Future<int?> getHealthSteps(DateTime start, DateTime end);
}
