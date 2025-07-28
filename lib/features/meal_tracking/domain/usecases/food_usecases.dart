import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/food_model.dart';
import '../repositories/food_repository.dart';

class AddFoodEntry {
  final FoodRepository _repository;

  AddFoodEntry(this._repository);

  Future<void> call(
    String userId,
    String mealType,
    String foodName,
    double calories,
    double protein,
    double fat,
    double carbs,
    double fiber,
  ) async {
    await _repository.addFoodEntry(
      userId,
      mealType,
      foodName,
      calories,
      protein,
      fat,
      carbs,
      fiber,
    );
  }
}

class GetFoodData {
  final FoodRepository _repository;

  GetFoodData(this._repository);

  Future<FoodItem?> call(String userId, String mealType) async {
    return await _repository.getFoodData(userId, mealType);
  }
}

class GetWeeklyFoodData {
  final FoodRepository _repository;

  GetWeeklyFoodData(this._repository);

  Future<AsyncValue<List<FoodItem>>> call(
    String userId,
    String mealType,
  ) async {
    return await _repository.getWeeklyFoodData(userId, mealType);
  }
}

class SetCalorieGoal {
  final FoodRepository _repository;

  SetCalorieGoal(this._repository);

  Future<void> call(String userId, double newGoal) async {
    await _repository.setCalorieGoal(userId, newGoal);
  }
}
