class DailyProgressModel {
  final String date;
  final Map<String, Map<String, dynamic>> metrics;

  DailyProgressModel({
    required this.date,
    required this.metrics,
  });

  factory DailyProgressModel.fromFirestore(
    String date,
    Map<String, Map<String, dynamic>> metricData,
  ) {
    return DailyProgressModel(
      date: date,
      metrics: metricData,
    );
  }

  // Calculate completion rate for a specific metric or all metrics
  double getCompletionRate({String? metric}) {
    if (metric != null && metrics.containsKey(metric)) {
      final data = metrics[metric]!;
      final completed = (data['completedGoals'] ?? 0) as num;
      final total = (data['totalGoals'] ?? 1) as num;
      return total > 0 ? completed / total : 0.0;
    }

    if (metrics.isEmpty) return 0.0;
    double totalRate = 0.0;
    int count = 0;
    metrics.forEach((_, data) {
      final completed = (data['completedGoals'] ?? 0) as num;
      final total = (data['totalGoals'] ?? 1) as num;
      totalRate += total > 0 ? completed / total : 0.0;
      count++;
    });
    return count > 0 ? totalRate / count : 0.0;
  }
}