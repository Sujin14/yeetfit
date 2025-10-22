import '../../data/model/food_model.dart';
import '../repositories/food_repository.dart';

// Use case for fetching food data.
class GetFoodData {
  final FoodRepository _repository;

  const GetFoodData(this._repository);

  Future<List<FoodItem>> call(String userId, String mealType) async {
    return await _repository.getFoodData(userId, mealType);
  }
}
