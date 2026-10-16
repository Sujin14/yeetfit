/// Steps, water, sleep and nutrition totals against their goals for one day.
class DailyProgress {
  final int steps;
  final int stepsGoal;
  final int glasses;
  final int waterGoal;
  final double hoursSlept;
  final double sleepGoal;
  final double calories;
  final double caloriesGoal;
  final double protein;
  final double proteinGoal;
  final double carbs;
  final double carbsGoal;
  final double fat;
  final double fatGoal;

  const DailyProgress({
    required this.steps,
    required this.stepsGoal,
    required this.glasses,
    required this.waterGoal,
    required this.hoursSlept,
    required this.sleepGoal,
    required this.calories,
    required this.caloriesGoal,
    required this.protein,
    required this.proteinGoal,
    required this.carbs,
    required this.carbsGoal,
    required this.fat,
    required this.fatGoal,
  });
}
