import '../entities/water_data.dart';

// Abstract repository for water tracking operations.
abstract class WaterRepository {
  // Fetches today's water data.
  Future<WaterData?> getWaterData(String userId);

  // Adds one glass of water.
  Future<void> addGlass(String userId);

  // Removes one glass of water (if >0).
  Future<void> removeGlass(String userId);

  // Sets water goal for today.
  Future<void> setWaterGoal(String userId, int newGoal);

  // Fetches weekly water data.
  Future<List<WaterData>> getWeeklyWaterData(String userId);
}
