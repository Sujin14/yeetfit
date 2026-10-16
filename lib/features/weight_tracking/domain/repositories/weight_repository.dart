import '../entities/weight_data.dart';

// Abstract repository for weight tracking operations.
abstract class WeightRepository {
  // Fetches today's weight data for user.
  Future<WeightData?> getWeightData(String userId);

  // Fetches user's weight goal.
  Future<WeightData?> getUserWeightGoal(String userId);

  // Updates weight entry (merges current with optional goal details).
  Future<void> updateWeight(
    String userId,
    double currentWeight,
    double? goalWeight,
    double? initialWeight,
    DateTime? targetDate,
  );

  // Sets user's weight goal.
  Future<void> setUserWeightGoal(
    String userId,
    double goalWeight,
    double initialWeight,
    DateTime? targetDate,
  );

  // Fetches weekly weight data.
  Future<List<WeightData>> getWeeklyWeightData(String userId);

  // Updates only current weight (merges with existing goal).
  Future<void> updateCurrentWeight(String userId, double currentWeight);
}
