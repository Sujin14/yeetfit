import 'dart:math';
import '../entities/mood_entry.dart';
import '../entities/mood_fitness_correlation.dart';

/// Pairs daily mood with daily fitness completion over a trailing window and
/// computes their Pearson correlation. Pure and synchronous.
class CorrelateMoodWithFitness {
  static const int windowDays = 30;

  const CorrelateMoodWithFitness();

  /// [fitnessByDate] maps 'yyyy-MM-dd' to a completion ratio (0–1); days
  /// missing from it have no fitness data and are left unpaired.
  MoodFitnessCorrelation call({
    required List<MoodEntry> moods,
    required Map<String, double> fitnessByDate,
    required DateTime today,
  }) {
    final moodByDate = {for (final entry in moods) entry.date: entry.score};
    final days = <MoodFitnessDay>[];
    final pairedMood = <double>[];
    final pairedFitness = <double>[];

    for (var offset = windowDays - 1; offset >= 0; offset--) {
      final date = DateTime(today.year, today.month, today.day - offset);
      final key = date.toIso8601String().split('T')[0];
      final mood = moodByDate[key];
      final ratio = fitnessByDate[key];
      final percent = ((ratio ?? 0).clamp(0.0, 1.0)) * 100;

      days.add(MoodFitnessDay(date: date, mood: mood, fitnessPercent: percent));
      if (mood != null && ratio != null) {
        pairedMood.add(mood.toDouble());
        pairedFitness.add(percent);
      }
    }

    return MoodFitnessCorrelation(
      days: days,
      pairedDays: pairedMood.length,
      pearson: pearson(pairedMood, pairedFitness),
    );
  }

  static double? pearson(List<double> x, List<double> y) {
    final n = x.length;
    if (n < 2 || n != y.length) return null;
    final meanX = x.reduce((a, b) => a + b) / n;
    final meanY = y.reduce((a, b) => a + b) / n;

    var covariance = 0.0, varianceX = 0.0, varianceY = 0.0;
    for (var i = 0; i < n; i++) {
      final dx = x[i] - meanX;
      final dy = y[i] - meanY;
      covariance += dx * dy;
      varianceX += dx * dx;
      varianceY += dy * dy;
    }
    if (varianceX == 0 || varianceY == 0) return null;
    return covariance / sqrt(varianceX * varianceY);
  }
}
