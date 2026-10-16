import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/progress/domain/entities/daily_progress.dart';
import 'package:yeetfit/features/progress/domain/entities/progress_metric.dart';
import 'package:yeetfit/features/progress/presentation/providers/progress_provider.dart';
import '../../domain/entities/mood_fitness_correlation.dart';
import '../../domain/usecases/correlate_mood_with_fitness.dart';
import 'mood_provider.dart';

/// Mood history paired with the Progress tab's monthly completion data over
/// the last 30 days (which can span the previous month).
final moodFitnessCorrelationProvider = Provider.autoDispose
    .family<AsyncValue<MoodFitnessCorrelation>, String>((ref, userId) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final windowStart = today.subtract(
        const Duration(days: CorrelateMoodWithFitness.windowDays - 1),
      );

      final months = {
        DateTime(windowStart.year, windowStart.month),
        DateTime(today.year, today.month),
      };
      final progressValues = [
        for (final month in months)
          ref.watch(
            monthlyProgressProvider((month: month, metric: ProgressMetric.all)),
          ),
      ];
      final moodsAsync = ref.watch(moodHistoryProvider(userId));

      for (final value in [moodsAsync, ...progressValues]) {
        if (value.hasError) {
          return AsyncValue.error(value.error!, value.stackTrace!);
        }
      }
      final moods = moodsAsync.value;
      final progress = progressValues.map((value) => value.value).toList();
      if (moods == null || progress.contains(null)) {
        return const AsyncValue.loading();
      }

      final todayKey = today.toIso8601String().split('T')[0];
      final fitnessByDate = <String, double>{
        for (final entries in progress.cast<List<DailyProgress>>())
          for (final entry in entries)
            // Future days of the current month are placeholders, not data.
            if (entry.date.compareTo(todayKey) <= 0)
              entry.date: entry.completionRate ?? 0.0,
      };

      return AsyncValue.data(
        const CorrelateMoodWithFitness()(
          moods: moods,
          fitnessByDate: fitnessByDate,
          today: today,
        ),
      );
    });
