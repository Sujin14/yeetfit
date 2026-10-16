// Saved steps and goal for one day.
class StepsData {
  final String date;
  final int steps;
  final int goalSteps;
  final double caloriesBurned;

  const StepsData({
    required this.date,
    required this.steps,
    required this.goalSteps,
    required this.caloriesBurned,
  });

  /// Rough estimates for an average adult stride.
  static double caloriesFor(int steps) => steps * 0.04;
  static double distanceKmFor(int steps) => steps * 0.762 / 1000;
}
