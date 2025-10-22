import '../../data/model/food_model.dart';
import '../repositories/food_repository.dart';

// Use case for fetching weekly food data.
class GetWeeklyFoodData {
  final FoodRepository _repository;

  const GetWeeklyFoodData(this._repository);

  Future<List<FoodItem>> call(String userId, String mealType) async {
    return await _repository.getWeeklyFoodData(userId, mealType);
  }
}