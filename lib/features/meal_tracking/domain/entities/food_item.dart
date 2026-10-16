/// A logged food entry, or a food search result not yet logged.
class FoodItem {
  /// Firestore document ID; `null` for items not yet logged (search results).
  final String? id;
  final String date;
  final String mealType;
  final String foodName;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;
  final double quantity;
  final String? image;

  const FoodItem({
    this.id,
    required this.date,
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.quantity,
    this.image,
  });

  FoodItem copyWith({String? mealType}) {
    return FoodItem(
      id: id,
      date: date,
      mealType: mealType ?? this.mealType,
      foodName: foodName,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
      fiber: fiber,
      quantity: quantity,
      image: image,
    );
  }
}
