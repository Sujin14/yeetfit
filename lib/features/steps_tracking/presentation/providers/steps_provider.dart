import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/steps_datasource.dart';
import '../../domain/entities/steps_data.dart';
import '../../data/repositories/steps_repository_impl.dart';
import '../../domain/repositories/steps_repository.dart';

const int defaultStepsGoal = 10000;

String _dateKey(DateTime date) => date.toIso8601String().split('T')[0];

final stepsRepositoryProvider = Provider<StepsRepository>(
  (ref) => StepsRepositoryImpl(StepsDataSource()),
);

/// Today's steps from Health Connect, polled every minute while watched
/// (steps screen, dashboard). `null` data means Health Connect is missing or
/// access isn't granted.
final stepsCountProvider = AsyncNotifierProvider.autoDispose
    .family<StepsCountNotifier, int?, String>(StepsCountNotifier.new);

final stepsGoalProvider = AsyncNotifierProvider.autoDispose
    .family<StepsGoalNotifier, int, String>(StepsGoalNotifier.new);

final weeklyStepsDataProvider = FutureProvider.autoDispose
    .family<List<StepsData>, String>(
      (ref, userId) =>
          ref.read(stepsRepositoryProvider).getWeeklyStepsData(userId),
    );

/// Flips to `true` at most once per day, when a poll finds today's steps at
/// or above the goal; the screen navigates to the success page and calls
/// `reset()`.
final stepsNavigationProvider = NotifierProvider.autoDispose
    .family<StepsNavigationNotifier, bool, String>(StepsNavigationNotifier.new);

/// Monday-to-Sunday of the current week, with today's live count merged in.
final chartDataProvider = Provider.autoDispose.family<List<StepsData>, String>((
  ref,
  userId,
) {
  final weeklyData = ref.watch(weeklyStepsDataProvider(userId)).value ?? [];
  final todaySteps = ref.watch(stepsCountProvider(userId)).value ?? 0;
  final todayGoal =
      ref.watch(stepsGoalProvider(userId)).value ?? defaultStepsGoal;
  final now = DateTime.now();
  final today = _dateKey(now);
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  return List.generate(7, (index) {
    final date = _dateKey(startOfWeek.add(Duration(days: index)));
    if (date == today) {
      return StepsData(
        date: date,
        steps: todaySteps,
        goalSteps: todayGoal,
        caloriesBurned: StepsData.caloriesFor(todaySteps),
      );
    }
    return weeklyData.firstWhere(
      (entry) => entry.date == date,
      orElse: () => StepsData(
        date: date,
        steps: 0,
        goalSteps: defaultStepsGoal,
        caloriesBurned: 0,
      ),
    );
  });
});

final chartConfigProvider = Provider.autoDispose
    .family<({double maxY, double interval}), String>((ref, userId) {
      final maxGoal = ref
          .watch(chartDataProvider(userId))
          .map((entry) => entry.goalSteps.toDouble())
          .reduce((a, b) => a > b ? a : b);
      final interval = switch (maxGoal) {
        <= 5000 => 1000.0,
        <= 10000 => 2000.0,
        <= 20000 => 5000.0,
        _ => 10000.0,
      };
      return (maxY: (maxGoal * 1.2).ceilToDouble(), interval: interval);
    });

String formatStepCount(double value) =>
    value >= 1000 ? '${(value / 1000).floor()}k' : '${value.toInt()}';

class StepsCountNotifier extends AsyncNotifier<int?> {
  static const _pollInterval = Duration(minutes: 1);
  static const _backfillDays = 6;

  final String userId;
  late StepsRepository _repository;
  Timer? _pollTimer;
  int? _lastSavedSteps;

  StepsCountNotifier(this.userId);

  @override
  Future<int?> build() async {
    _repository = ref.read(stepsRepositoryProvider);
    ref.onDispose(() => _pollTimer?.cancel());
    try {
      await _repository.requestHealthAccessOnce();
    } catch (e) {
      debugPrint('Steps: Health Connect access request failed: $e');
    }
    if (!ref.mounted) return null;
    _pollTimer = Timer.periodic(_pollInterval, (_) => _poll());
    unawaited(_backfillRecentDays());
    unawaited(
      _repository
          .syncLocalData(userId)
          .catchError((Object e) => debugPrint('Steps: sync failed: $e')),
    );
    return _readTodaySteps();
  }

  /// Today's count, saved to Firestore when it changed. A failed save keeps
  /// the count.
  Future<int?> _readTodaySteps() async {
    final now = DateTime.now();
    final steps = await _repository.getHealthSteps(
      DateTime(now.year, now.month, now.day),
      now,
    );
    if (steps != null && steps != _lastSavedSteps) {
      _lastSavedSteps = steps;
      try {
        await _repository.updateDailySteps(userId, _dateKey(now), steps);
      } catch (e) {
        debugPrint('Steps: saving today failed: $e');
      }
    }
    return steps;
  }

  /// Opens the Health Connect permission screen (or its store listing).
  Future<void> requestAccess() async {
    try {
      await _repository.requestHealthAccess();
    } catch (e) {
      debugPrint('Steps: Health Connect access request failed: $e');
    }
    await _poll();
  }

  Future<void> _poll() async {
    try {
      final steps = await _readTodaySteps();
      if (ref.mounted) state = AsyncData(steps);
    } catch (e, st) {
      debugPrint('Steps: poll failed: $e');
      // Keep showing the last count when a later poll fails.
      if (ref.mounted && !state.hasValue) state = AsyncError(e, st);
    }
  }

  /// Saves the full count of recent days, which only got the count from
  /// whenever the app was last open that day.
  Future<void> _backfillRecentDays() async {
    try {
      final saved = {
        for (final day in await _repository.getWeeklyStepsData(userId))
          day.date: day.steps,
      };
      final now = DateTime.now();
      var changed = false;
      for (var offset = 1; offset <= _backfillDays; offset++) {
        final start = DateTime(now.year, now.month, now.day - offset);
        final end = DateTime(start.year, start.month, start.day + 1);
        final steps = await _repository.getHealthSteps(start, end);
        if (steps == null || !ref.mounted) return;
        final date = _dateKey(start);
        if (steps > (saved[date] ?? 0)) {
          await _repository.updateDailySteps(userId, date, steps);
          changed = true;
        }
      }
      if (changed && ref.mounted) {
        ref.invalidate(weeklyStepsDataProvider(userId));
      }
    } catch (e) {
      debugPrint('Steps: backfill failed: $e');
    }
  }
}

class StepsGoalNotifier extends AsyncNotifier<int> {
  final String userId;

  StepsGoalNotifier(this.userId);

  StepsRepository get _repository => ref.read(stepsRepositoryProvider);

  @override
  Future<int> build() => _fetchGoal();

  Future<int> _fetchGoal() =>
      _repository.getStepsGoal(userId, _dateKey(DateTime.now()));

  Future<void> setGoal(int newGoal) async {
    final repository = _repository;
    final result = await AsyncValue.guard(() async {
      await repository.setStepsGoal(userId, newGoal);
      return repository.getStepsGoal(userId, _dateKey(DateTime.now()));
    });
    if (ref.mounted) state = result;
  }
}

class StepsNavigationNotifier extends Notifier<bool> {
  final String userId;

  StepsNavigationNotifier(this.userId);

  @override
  bool build() {
    ref.listen<AsyncValue<int?>>(
      stepsCountProvider(userId),
      (_, next) => _onSteps(next.value),
    );
    return false;
  }

  // Persisted so reopening the screen later the same day doesn't celebrate
  // again.
  String get _shownDateKey => 'steps_success_shown_$userId';

  Future<void> _onSteps(int? steps) async {
    final goal = ref.read(stepsGoalProvider(userId)).value;
    if (steps == null || goal == null || goal <= 0 || steps < goal) return;
    final today = _dateKey(DateTime.now());
    final prefs = await SharedPreferences.getInstance();
    final hasShownSuccessToday = prefs.getString(_shownDateKey) == today;
    if (hasShownSuccessToday || !ref.mounted) return;
    await prefs.setString(_shownDateKey, today);
    if (ref.mounted) state = true;
  }

  void reset() => state = false;
}
