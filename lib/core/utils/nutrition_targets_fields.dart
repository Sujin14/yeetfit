import '../entities/nutrition_targets.dart';
import 'nutrition_targets_calculator.dart';

/// Reads and writes [NutritionTargets] on the `users/{uid}` document.
abstract final class NutritionTargetsFields {
  static const calories = 'dailyCalorieTarget';
  static const protein = 'dailyProteinTarget';
  static const carbs = 'dailyCarbTarget';
  static const fat = 'dailyFatTarget';

  static Map<String, int> toMap(NutritionTargets targets) => {
    calories: targets.calories,
    protein: targets.protein,
    carbs: targets.carbs,
    fat: targets.fat,
  };

  /// The saved targets, or null when no calorie target has been saved.
  static NutritionTargets? saved(Map<String, dynamic>? userData) {
    final savedCalories = _asNum(userData?[calories]);
    if (savedCalories == null || savedCalories <= 0) return null;
    return NutritionTargets(
      calories: savedCalories.round(),
      protein: _asNum(userData?[protein])?.round() ?? 0,
      carbs: _asNum(userData?[carbs])?.round() ?? 0,
      fat: _asNum(userData?[fat])?.round() ?? 0,
    );
  }

  /// Targets computed from the profile fields in [userData], or null when
  /// gender, age, weight or height is missing.
  static NutritionTargets? calculate(Map<String, dynamic>? userData) =>
      NutritionTargetsCalculator.calculate(
        gender: userData?['gender']?.toString(),
        age: _asNum(userData?['age']),
        weightKg: _asNum(userData?['currentWeight']),
        heightCm: _asNum(userData?['height']),
        activityLevel: userData?['activityLevel']?.toString(),
        goal: userData?['goal']?.toString(),
      );

  static num? _asNum(Object? value) => switch (value) {
    num() => value,
    String() => num.tryParse(value),
    _ => null,
  };
}
