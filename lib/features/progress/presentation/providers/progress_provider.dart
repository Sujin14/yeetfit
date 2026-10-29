import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/utils/nutrition_targets_fields.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/providers/user_document_provider.dart';
import '../../data/datasources/progress_datasource.dart';
import '../../data/model/daily_progress_model.dart';
import '../../domain/entities/daily_progress.dart';
import '../../domain/entities/progress_metric.dart';

final progressDataSourceProvider = Provider<ProgressDataSource>(
  (ref) => ProgressDataSource(),
);

/// Metric chip selected on the Progress tab.
final selectedProgressMetricProvider =
    NotifierProvider<SelectedProgressMetricNotifier, ProgressMetric>(
      SelectedProgressMetricNotifier.new,
    );

class SelectedProgressMetricNotifier extends Notifier<ProgressMetric> {
  @override
  ProgressMetric build() => ProgressMetric.all;

  void select(ProgressMetric metric) => state = metric;
}

/// Month shown on the Progress calendar (year + month only). Defaults to now.
final selectedProgressMonthProvider =
    NotifierProvider<SelectedProgressMonthNotifier, DateTime>(
      SelectedProgressMonthNotifier.new,
    );

class SelectedProgressMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void previous() {
    state = DateTime(state.year, state.month - 1);
  }

  void next() {
    if (!canGoNext) return;
    state = DateTime(state.year, state.month + 1);
  }

  bool get canGoNext {
    final now = DateTime.now();
    final current = DateTime(now.year, now.month);
    return DateTime(state.year, state.month + 1).compareTo(current) <= 0;
  }
}

typedef ProgressQuery = ({DateTime month, ProgressMetric metric});

/// `dailyCalorieTarget` from the user's profile, or null while it's missing
/// or zero. Only changes to that field notify listeners.
final progressCalorieTargetProvider = FutureProvider.autoDispose
    .family<int?, String>(
      (ref, userId) => ref.watch(
        userDocumentProvider(
          userId,
        ).selectAsync((data) => NutritionTargetsFields.saved(data)?.calories),
      ),
    );

/// Raw per-day docs of a month for one metric; refetches when the signed-in
/// user changes. Errors surface immediately (with a manual retry) instead of
/// Riverpod's automatic retry, since each attempt can take up to 12s per
/// metric. Retry by invalidating this provider.
final monthlyProgressDataProvider = FutureProvider.autoDispose
    .family<List<DailyProgressModel>, ProgressQuery>((ref, query) {
      final userId = ref.watch(authUserIdProvider);
      if (userId == null) throw Exception('User not authenticated');
      return ref
          .read(progressDataSourceProvider)
          .getMonthlyProgress(userId, query.month, metric: query.metric);
    }, retry: (_, _) => null);

/// Completion per day of a month for one metric. Calories are measured
/// against the profile's calorie target.
final monthlyProgressProvider = FutureProvider.autoDispose
    .family<List<DailyProgress>, ProgressQuery>((ref, query) async {
      final userId = ref.watch(authUserIdProvider);
      if (userId == null) throw Exception('User not authenticated');

      final usesCalories =
          query.metric == ProgressMetric.calories ||
          query.metric == ProgressMetric.all;
      final calorieGoal = usesCalories
          ? await ref.watch(progressCalorieTargetProvider(userId).future)
          : null;
      final days = await ref.watch(monthlyProgressDataProvider(query).future);
      return [
        for (final day in days)
          DailyProgress(
            date: day.date,
            completionRate: day.getCompletionRate(
              query.metric,
              calorieGoal: calorieGoal,
            ),
          ),
      ];
    }, retry: (_, _) => null);
