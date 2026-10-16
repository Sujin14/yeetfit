import '../entities/food_item.dart';

abstract class FoodRepository {
  /// Every logged entry for [date] across all meal slots.
  Stream<List<FoodItem>> watchTodayMeals(String userId, String date);

  /// Logs [item] under today's date.
  Future<void> addFoodEntry(String userId, FoodItem item);

  Future<void> deleteFoodEntry(String userId, String entryId);

  /// Entries from the last 7 days, today included.
  Future<List<FoodItem>> getWeeklyFoodData(String userId);
}
