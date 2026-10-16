import '../entities/food_item.dart';
import '../repositories/food_repository.dart';

/// The single path for logging food: manual entry, search and meal scan.
class AddFoodEntry {
  final FoodRepository _repository;

  const AddFoodEntry(this._repository);

  Future<void> call(String userId, FoodItem item) {
    if (item.foodName.trim().isEmpty) {
      throw ArgumentError.value(item.foodName, 'foodName', 'must not be empty');
    }
    if (item.mealType.trim().isEmpty) {
      throw ArgumentError.value(item.mealType, 'mealType', 'must not be empty');
    }
    return _repository.addFoodEntry(userId, item);
  }
}
