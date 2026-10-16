import 'dart:math' as math;
import '../entities/nutrition_targets.dart';

/// Calorie adjustment on top of TDEE and the macro split for each goal.
enum _GoalPlan {
  weightLoss(-500, protein: 0.35, carbs: 0.40, fat: 0.25),
  muscleGain(300, protein: 0.30, carbs: 0.50, fat: 0.20),
  maintenance(0, protein: 0.25, carbs: 0.50, fat: 0.25),
  recomposition(-200, protein: 0.40, carbs: 0.35, fat: 0.25);

  final int calorieAdjustment;
  final double protein;
  final double carbs;
  final double fat;

  const _GoalPlan(
    this.calorieAdjustment, {
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  /// Unknown or empty goals are treated as maintenance.
  static _GoalPlan from(String? goal) => switch (goal?.trim().toLowerCase()) {
    'weight loss' || 'lose weight' => weightLoss,
    'weight gain' ||
    'gain weight' ||
    'muscle building' ||
    'muscle gain' ||
    'build muscle' => muscleGain,
    'body recomposition' || 'recomposition' => recomposition,
    _ => maintenance,
  };
}

/// Mifflin-St Jeor TDEE adjusted for the user's goal, with the matching
/// macro split.
abstract final class NutritionTargetsCalculator {
  // Keys are lower-cased; the app stores e.g. 'Moderately Active'.
  static const _activityMultipliers = {
    'sedentary': 1.2,
    'light': 1.375,
    'lightly active': 1.375,
    'moderate': 1.55,
    'moderately active': 1.55,
    'active': 1.725,
    'very active': 1.9,
  };
  static const _defaultActivityMultiplier = 1.55;

  /// Returns null when gender, age, weight or height is missing, so callers
  /// leave any saved targets untouched.
  static NutritionTargets? calculate({
    required String? gender,
    required num? age,
    required num? weightKg,
    required num? heightCm,
    String? activityLevel,
    String? goal,
  }) {
    final sex = gender?.trim().toLowerCase() ?? '';
    if (sex.isEmpty ||
        age == null ||
        age <= 0 ||
        weightKg == null ||
        weightKg <= 0 ||
        heightCm == null ||
        heightCm <= 0) {
      return null;
    }

    final baseBmr = 10 * weightKg + 6.25 * heightCm - 5 * age;
    final bmr = switch (sex) {
      'male' => baseBmr + 5,
      'female' => baseBmr - 161,
      // Average of the male (+5) and female (-161) constants.
      _ => baseBmr - 78,
    };
    final multiplier =
        _activityMultipliers[activityLevel?.trim().toLowerCase()] ??
        _defaultActivityMultiplier;
    final plan = _GoalPlan.from(goal);

    var calories = _roundToNearest50(bmr * multiplier + plan.calorieAdjustment);
    if (plan == _GoalPlan.weightLoss) {
      calories = math.max(calories, _minimumWeightLossCalories(sex));
    }

    return NutritionTargets(
      calories: calories,
      protein: (calories * plan.protein / 4).round(),
      carbs: (calories * plan.carbs / 4).round(),
      fat: (calories * plan.fat / 9).round(),
    );
  }

  static int _roundToNearest50(num calories) => (calories / 50).round() * 50;

  static int _minimumWeightLossCalories(String sex) => switch (sex) {
    'male' => 1500,
    'female' => 1200,
    _ => 1350,
  };
}
