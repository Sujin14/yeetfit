/// Daily calorie (kcal) and macro (grams) targets for a user.
class NutritionTargets {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const NutritionTargets({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}
