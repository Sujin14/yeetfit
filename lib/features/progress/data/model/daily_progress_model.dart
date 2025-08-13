class DailyProgressModel {
  final String date;
  final Map<String, Map<String, dynamic>> metrics;

  DailyProgressModel({required this.date, required this.metrics});

  factory DailyProgressModel.fromFirestore(
    String date,
    Map<String, Map<String, dynamic>> metricData,
  ) {
    return DailyProgressModel(date: date, metrics: metricData);
  }

  double getCompletionRate({String? metric}) {
    if (metrics.isEmpty) return 0.0;

    if (metric != null) {
      final data = metrics[metric];
      final goalData = metrics['${metric}_goal'];
      if (data == null || goalData == null) return 0.0;

      switch (metric.toLowerCase()) {
        case 'steps':
          final steps = (data['steps'] as num?)?.toDouble() ?? 0.0;
          final goalSteps =
              (goalData['goalSteps'] as num?)?.toDouble() ?? 10000.0;
          return goalSteps > 0 ? (steps / goalSteps).clamp(0.0, 1.0) : 0.0;
        case 'water':
          final glasses = (data['glassesConsumed'] as num?)?.toDouble() ?? 0.0;
          final goalGlasses =
              (goalData['goalGlasses'] as num?)?.toDouble() ?? 8.0;
          return goalGlasses > 0
              ? (glasses / goalGlasses).clamp(0.0, 1.0)
              : 0.0;
        case 'sleep':
          final duration = (data['duration'] as num?)?.toDouble() ?? 0.0;
          final goalHours = (goalData['goalHours'] as num?)?.toDouble() ?? 8.0;
          return goalHours > 0 ? (duration / goalHours).clamp(0.0, 1.0) : 0.0;
        case 'weight':
          final currentWeight =
              (data['currentWeight'] as num?)?.toDouble() ?? 77.0;
          final goalWeight =
              (goalData['goalWeight'] as num?)?.toDouble() ?? 70.0;
          final userDoc = metrics['user'] ?? {};
          final initialWeight =
              (userDoc['weight'] as num?)?.toDouble() ?? currentWeight;
          final weightChange = (initialWeight - currentWeight).abs();
          final goalChange = (initialWeight - goalWeight).abs();
          return goalChange > 0
              ? (weightChange / goalChange).clamp(0.0, 1.0)
              : 0.0;
        case 'food':
          final calories = (data['calories'] as num?)?.toDouble() ?? 0.0;
          final caloriesGoal =
              (goalData['caloriesGoal'] as num?)?.toDouble() ?? 1750.0;
          return caloriesGoal > 0
              ? (calories / caloriesGoal).clamp(0.0, 1.0)
              : 0.0;
        default:
          return 0.0;
      }
    }

    // Average completion rate for all metrics
    double totalRate = 0.0;
    int count = 0;
    for (var key in metrics.keys) {
      if (key.endsWith('_goal')) continue;
      final rate = getCompletionRate(metric: key);
      totalRate += rate;
      count++;
    }
    return count > 0 ? totalRate / count : 0.0;
  }
}
