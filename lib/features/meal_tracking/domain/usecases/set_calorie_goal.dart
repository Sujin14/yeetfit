import '../repositories/food_repository.dart';

// Use case for setting calorie goal.
class SetCalorieGoal {
  final FoodRepository _repository;

  const SetCalorieGoal(this._repository);

  Future<void> call(String userId, double newGoal) async {
    await _repository.setCalorieGoal(userId, newGoal);
  }
}
