import '../../domain/entities/progress_metric.dart';

/// Raw per-metric documents for one day, keyed by [ProgressMetric].
class DailyProgressModel {
  final String date; // yyyy-MM-dd
  final Map<ProgressMetric, Map<String, dynamic>> metrics;

  DailyProgressModel({required this.date, required this.metrics});

  static double _getNum(
    Map<String, dynamic> map,
    List<String> keys,
    double fallback,
  ) {
    for (final key in keys) {
      final value = map[key];
      if (value is num) return value.toDouble();
    }
    return fallback;
  }

  static double _ratio(double value, double goal) =>
      goal > 0 ? (value / goal).clamp(0.0, 1.0) : 0.0;

  /// 0–1 completion for [metric], or null when it wasn't logged that day.
  /// Calories need the profile's [calorieGoal]; without one they're null.
  ///
  /// For [ProgressMetric.all] this is the mean over the fitness metrics, with
  /// unlogged ones counted as 0, so one finished metric alone can't make the
  /// day look complete. Calories are left out while there's no goal.
  double? getCompletionRate(ProgressMetric metric, {int? calorieGoal}) {
    if (metric == ProgressMetric.all) {
      final hasCalorieGoal = (calorieGoal ?? 0) > 0;
      final tracked = [
        for (final m in ProgressMetric.fitness)
          if (m != ProgressMetric.calories || hasCalorieGoal) m,
      ];
      final logged = tracked.where(metrics.containsKey);
      if (logged.isEmpty) return null;
      final total = logged.fold<double>(
        0,
        (sum, m) => sum + getCompletionRate(m, calorieGoal: calorieGoal)!,
      );
      return total / tracked.length;
    }

    final data = metrics[metric];
    if (data == null) return null;

    return switch (metric) {
      ProgressMetric.steps => _ratio(
        _getNum(data, ['steps', 'count'], 0.0),
        _getNum(data, ['goalSteps', 'target', 'value'], 10000.0),
      ),
      ProgressMetric.water => _ratio(
        _getNum(data, ['glassesConsumed', 'glasses'], 0.0),
        _getNum(data, ['goalGlasses', 'target', 'value'], 8.0),
      ),
      ProgressMetric.sleep => _ratio(
        _getNum(data, ['duration', 'hours'], 0.0),
        _getNum(data, ['goalHours', 'target', 'value'], 8.0),
      ),
      ProgressMetric.calories =>
        calorieGoal == null || calorieGoal <= 0
            ? null
            : _ratio(_getNum(data, ['calories'], 0.0), calorieGoal.toDouble()),
      ProgressMetric.mood => _ratio(_getNum(data, ['score'], 0.0), 5.0),
      ProgressMetric.all => null,
    };
  }
}
