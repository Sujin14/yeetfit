/// Nutrition estimate returned by the AI meal photo scanner.
class ScannedMeal {
  final String foodName;
  final String servingSize;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const ScannedMeal({
    required this.foodName,
    required this.servingSize,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory ScannedMeal.fromJson(Map<String, dynamic> json) {
    return ScannedMeal(
      foodName: (json['foodName'] as String?)?.trim() ?? '',
      servingSize: (json['servingSize'] as String?)?.trim() ?? '',
      calories: _toDouble(json['calories']),
      protein: _toDouble(json['protein']),
      carbs: _toDouble(json['carbs']),
      fat: _toDouble(json['fat']),
    );
  }

  // The model occasionally returns numbers as strings ("12" or "12g").
  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final match = RegExp(r'\d+(\.\d+)?').firstMatch(value);
      if (match != null) return double.parse(match.group(0)!);
    }
    return 0;
  }

  ScannedMeal copyWith({
    String? foodName,
    String? servingSize,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) {
    return ScannedMeal(
      foodName: foodName ?? this.foodName,
      servingSize: servingSize ?? this.servingSize,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }
}
