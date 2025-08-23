import 'package:flutter/foundation.dart';

class DailyProgressModel {
  final String date; // yyyy-MM-dd
  final Map<String, Map<String, dynamic>> metrics;

  DailyProgressModel({required this.date, required this.metrics});

  factory DailyProgressModel.fromFirestore(
    String date,
    Map<String, Map<String, dynamic>> metricData,
  ) {
    return DailyProgressModel(date: date, metrics: metricData);
  }

  double _getNum(Map<String, dynamic>? map, List<String> keys, double fallback) {
    if (map == null) return fallback;
    for (final k in keys) {
      final v = map[k];
      if (v is num) return v.toDouble();
    }
    return fallback;
  }

  double getCompletionRate({String? metric}) {
    debugPrint(
      '[Model] getCompletionRate for date=$date metric=${metric ?? "ALL"} keys=${metrics.keys.toList()}',
    );

    if (metrics.isEmpty) {
      debugPrint('[Model] metrics empty for $date -> returning 0.0');
      return 0.0;
    }

    if (metric != null) {
      final m = metric.toLowerCase();
      final data = metrics[m];
      if (data == null) {
        debugPrint('[Model] missing data for $m on $date -> 0.0');
        return 0.0;
      }

      double result = 0.0;
      switch (m) {
        case 'steps':
          {
            final steps = _getNum(data, ['steps', 'count'], 0.0);
            final goalSteps = _getNum(data, ['goalSteps', 'target', 'value'], 10000.0);
            result = goalSteps > 0 ? (steps / goalSteps).clamp(0.0, 1.0) : 0.0;
            debugPrint('[Model] steps: $steps / $goalSteps = $result');
            return result;
          }
        case 'water':
          {
            final drank = _getNum(data, ['glassesConsumed', 'glasses'], 0.0);
            final goal = _getNum(data, ['goalGlasses', 'target', 'value'], 8.0);
            result = goal > 0 ? (drank / goal).clamp(0.0, 1.0) : 0.0;
            debugPrint('[Model] water: $drank / $goal = $result');
            return result;
          }
        case 'sleep':
          {
            final hours = _getNum(data, ['duration', 'hours'], 0.0);
            final goal = _getNum(data, ['goalHours', 'target', 'value'], 8.0);
            result = goal > 0 ? (hours / goal).clamp(0.0, 1.0) : 0.0;
            debugPrint('[Model] sleep: $hours / $goal = $result');
            return result;
          }
        case 'weight':
          {
            final current = _getNum(data, ['currentWeight', 'weight'], 0.0);
            final goal = _getNum(data, ['goalWeight', 'target', 'value'], 0.0);
            final initial = _getNum(data, ['initialWeight', 'start'], current);

            if (goal <= 0 || current <= 0 || initial <= 0) {
              debugPrint('[Model] weight invalid -> 0.0');
              return 0.0;
            }

            final traveled = (initial - current).abs();
            final total = (initial - goal).abs();
            result = total > 0 ? (traveled / total).clamp(0.0, 1.0) : 0.0;
            debugPrint(
              '[Model] weight: initial=$initial current=$current goal=$goal -> result=$result',
            );
            return result;
          }
        case 'food':
          {
            final kcal = _getNum(data, ['calories', 'kcal'], 0.0);
            final kcalGoal = _getNum(data, ['caloriesGoal', 'goalCalories'], 1750.0);
            result = kcalGoal > 0 ? (kcal / kcalGoal).clamp(0.0, 1.0) : 0.0;
            debugPrint('[Model] food: $kcal / $kcalGoal = $result');
            return result;
          }
        default:
          debugPrint('[Model] unknown metric $m -> 0.0');
          return 0.0;
      }
    }

    // Average across available metrics
    double total = 0.0;
    int count = 0;
    for (final key in metrics.keys) {
      final rate = getCompletionRate(metric: key);
      debugPrint('[Model] submetric rate for $key on $date = $rate');
      total += rate;
      count++;
    }
    final average = count > 0 ? total / count : 0.0;
    debugPrint('[Model] average completion for $date = $average (count=$count)');
    return average;
  }
}
