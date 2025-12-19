import '../../data/model/food_model.dart';

// Abstract repository for food/meal tracking.
abstract class FoodRepository {
  // Fetches today's food for meal type.
  Future<List<FoodItem>> getFoodData(String userId, String mealType);

  // Fetches today's calorie goal.
  Future<double> getCalorieGoal(String userId);

  // Adds food entry for today.
  Future<void> addFoodEntry(
    String userId,
    String mealType,
    String foodName,
    double calories,
    double protein,
    double fat,
    double carbs,
    double fiber,
    double quantity,
    String? image,
  );

  // Sets calorie goal for today.
  Future<void> setCalorieGoal(String userId, double newGoal);

  // Fetches weekly food for meal type.
  Future<List<FoodItem>> getWeeklyFoodData(String userId, String mealType);
}