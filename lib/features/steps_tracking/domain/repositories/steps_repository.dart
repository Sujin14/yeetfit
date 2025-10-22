import '../../data/model/steps_model.dart';

// Abstract repository for steps tracking operations.
abstract class StepsRepository {
  // Fetches steps data for a date.
  Future<StepsData?> getStepsData(String userId, String date);

  // Fetches steps goal for a date.
  Future<int> getStepsGoal(String userId, String date);

  // Adds steps entry for today.
  Future<void> addStepsEntry(String userId, int steps);

  // Sets steps goal for today.
  Future<void> setStepsGoal(String userId, int newGoal);

  // Fetches weekly steps data.
  Future<List<StepsData>> getWeeklyStepsData(String userId);

  // Syncs local data to Firestore.
  Future<void> syncLocalData(String userId);

  // Updates steps for a specific date.
  Future<void> updateDailySteps(String userId, String date, int steps);
}