import '../../domain/entities/food_item.dart';

/// Firestore and Edamam mapping for [FoodItem].
abstract final class FoodItemModel {
  static FoodItem fromMap(Map<String, dynamic> map, {String? id}) {
    return FoodItem(
      id: id,
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      mealType: map['mealType'] ?? '',
      foodName: map['foodName'] ?? '',
      calories: (map['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (map['protein'] as num?)?.toDouble() ?? 0.0,
      fat: (map['fat'] as num?)?.toDouble() ?? 0.0,
      carbs: (map['carbs'] as num?)?.toDouble() ?? 0.0,
      fiber: (map['fiber'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toDouble() ?? 100.0,
      image: map['image'] as String?,
    );
  }

  /// Entry fields as stored; the datasource adds `date` and `timestamp`.
  static Map<String, dynamic> toMap(FoodItem item) => {
    'mealType': item.mealType,
    'foodName': item.foodName,
    'calories': item.calories,
    'protein': item.protein,
    'fat': item.fat,
    'carbs': item.carbs,
    'fiber': item.fiber,
    'quantity': item.quantity,
    'image': item.image,
  };

  /// From an Edamam `food` object, scaled to [quantity] grams.
  static FoodItem fromEdamamJson(
    Map<String, dynamic> json, {
    required double quantity,
  }) {
    final nutrients = json['nutrients'] as Map<String, dynamic>? ?? {};
    final measures = json['measures'] as List<dynamic>? ?? [];
    final servingWeight = measures.isNotEmpty
        ? (measures.firstWhere(
                        (m) => m['label'] == 'Serving',
                        orElse: () => {'weight': 100.0},
                      )['weight']
                      as num?)
                  ?.toDouble() ??
              100.0
        : 100.0;
    final scale = quantity / servingWeight;
    return FoodItem(
      date: DateTime.now().toIso8601String().split('T')[0],
      mealType: '',
      foodName: json['label'] ?? 'Unknown Food',
      calories: ((nutrients['ENERC_KCAL'] as num?)?.toDouble() ?? 0.0) * scale,
      protein: ((nutrients['PROCNT'] as num?)?.toDouble() ?? 0.0) * scale,
      fat: ((nutrients['FAT'] as num?)?.toDouble() ?? 0.0) * scale,
      carbs: ((nutrients['CHOCDF'] as num?)?.toDouble() ?? 0.0) * scale,
      fiber: ((nutrients['FIBTG'] as num?)?.toDouble() ?? 0.0) * scale,
      quantity: quantity,
      image: json['image'] as String?,
    );
  }
}
