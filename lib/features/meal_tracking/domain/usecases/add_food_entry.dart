import '../repositories/food_repository.dart';

// Use case for adding food entry.
class AddFoodEntry {
  final FoodRepository _repository;

  const AddFoodEntry(this._repository);

  Future<void> call(
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
      quantity,
      image,
    );
  }
}
