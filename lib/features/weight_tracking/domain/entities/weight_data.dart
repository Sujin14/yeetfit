// Weight entry and goal for one day.
class WeightData {
  final String date;
  final double currentWeight;
  final double goalWeight;
  final double initialWeight;
  final DateTime? targetDate;

  const WeightData({
    required this.date,
    required this.currentWeight,
    required this.goalWeight,
    required this.initialWeight,
    this.targetDate,
  });
}
