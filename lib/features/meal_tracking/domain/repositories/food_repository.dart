import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/model/food_model.dart';

abstract class FoodRepository {
  Future<FoodItem?> getFoodData(String userId, String mealType);
  Future<double> getCalorieGoal(String userId);
  Future<void> addFoodEntry(
    String userId,
    String mealType,
    String foodName,
    double calories,
    double protein,
    double fat,
    double carbs,
    double fiber,
  );
  Future<void> setCalorieGoal(String userId, double newGoal);
  Future<AsyncValue<List<FoodItem>>> getWeeklyFoodData(String userId, String mealType);
}