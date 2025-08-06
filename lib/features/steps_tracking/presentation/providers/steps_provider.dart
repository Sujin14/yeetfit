import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import '../../data/datasources/steps_datasource.dart';
import '../../data/model/steps_model.dart';
import '../../data/repositories/steps_repository_impl.dart';
import '../../domain/usecases/add_steps_entry.dart';
import '../../domain/usecases/get_steps_data.dart';
import '../../domain/usecases/get_weekly_steps.dart';
import '../../domain/usecases/set_steps_goal.dart';

/// Repository provider
final stepsRepositoryProvider = Provider<StepsRepositoryImpl>(
  (ref) => StepsRepositoryImpl(StepsDataSource()),
);

/// UseCase providers
final addStepsEntryProvider = Provider<AddStepsEntry>(
  (ref) => AddStepsEntry(ref.read(stepsRepositoryProvider)),
);

final setStepsGoalProvider = Provider<SetStepsGoal>(
  (ref) => SetStepsGoal(ref.read(stepsRepositoryProvider)),
);

final getStepsDataProvider = Provider<GetStepsData>(
  (ref) => GetStepsData(ref.read(stepsRepositoryProvider)),
);

final getWeeklyStepsDataProvider = Provider<GetWeeklyStepsData>(
  (ref) => GetWeeklyStepsData(ref.read(stepsRepositoryProvider)),
);

/// Provider for steps count
final stepsCountProvider = StateNotifierProvider.autoDispose
    .family<StepsCountNotifier, AsyncValue<int>, String>(
      (ref, userId) => StepsCountNotifier(
        ref,
        ref.read(getStepsDataProvider),
        ref.read(addStepsEntryProvider),
        userId,
      ),
    );

/// Provider for steps goal
final stepsGoalProvider = StateNotifierProvider.autoDispose
    .family<StepsGoalNotifier, AsyncValue<int>, String>(
      (ref, userId) => StepsGoalNotifier(
        ref,
        ref.read(stepsRepositoryProvider),
        ref.read(setStepsGoalProvider),
        userId,
      ),
    );

/// Provider for calories burned
final caloriesBurnedProvider = Provider.autoDispose.family<double, String>((
  ref,
  userId,
) {
  final steps = ref.watch(
    stepsCountProvider(userId).select((value) => value.value ?? 0),
  );
  return steps * 0.04; // 0.04 calories per step
});

/// Provider for daily progress color
final dailyStepsProgressColorProvider = Provider.autoDispose
    .family<Color, String>((ref, userIdAndDate) {
      final parts = userIdAndDate.split('|');
      final userId = parts[0];
      final date = parts[1];
      final weeklyData = ref.watch(weeklyStepsDataProvider(userId)).value ?? [];
      final today = DateTime.now().toIso8601String().split('T')[0];
      final steps = date == today
          ? ref.watch(
              stepsCountProvider(userId).select((value) => value.value ?? 0),
            )
          : (weeklyData
                .firstWhere(
                  (entry) => entry.date == date,
                  orElse: () => StepsData(
                    date: date,
                    steps: 0,
                    goalSteps: 10000,
                    caloriesBurned: 0.0,
                  ),
                )
                .steps);
      final goalSteps = date == today
          ? ref.watch(
              stepsGoalProvider(userId).select((value) => value.value ?? 10000),
            )
          : (weeklyData
                .firstWhere(
                  (entry) => entry.date == date,
                  orElse: () => StepsData(
                    date: date,
                    steps: 0,
                    goalSteps: 10000,
                    caloriesBurned: 0.0,
                  ),
                )
                .goalSteps);
      final progress = goalSteps > 0 ? steps / goalSteps : 0.0;

      if (progress >= 1.0) return const Color(0xFF4CAF50); // Green for 100%
      if (progress > 0.5) return const Color(0xFFFFEB3B); // Yellow for >50%
      if (progress >= 0.25) return const Color(0xFFFF9800); // Orange for ~50%
      return const Color(0xFFF44336); // Red for <25%
    });

/// Weekly Steps Data Provider
final weeklyStepsDataProvider = FutureProvider.family<List<StepsData>, String>((
  ref,
  userId,
) async {
  final asyncResult = await ref.read(getWeeklyStepsDataProvider).call(userId);
  final weeklyData = asyncResult.when(
    data: (data) => data,
    error: (e, _) => throw e,
    loading: () => [],
  );
  final today = DateTime.now().toIso8601String().split('T')[0];
  final steps = ref.watch(
    stepsCountProvider(userId).select((value) => value.value ?? 0),
  );
  final goalSteps = ref.watch(
    stepsGoalProvider(userId).select((value) => value.value ?? 10000),
  );
  final caloriesBurned = ref.watch(caloriesBurnedProvider(userId));
  final updatedData = weeklyData.where((data) => data.date != today).toList()
    ..add(
      StepsData(
        date: today,
        steps: steps,
        goalSteps: goalSteps,
        caloriesBurned: caloriesBurned,
      ),
    );
  updatedData.sort((a, b) => a.date.compareTo(b.date));
  return updatedData.cast<StepsData>();
});

/// Notifier for steps count
class StepsCountNotifier extends StateNotifier<AsyncValue<int>> {
  final Ref _ref;
  final GetStepsData _getStepsData;
  final AddStepsEntry _addStepsEntry;
  final String _userId;

  late StreamSubscription<StepCount> _stepCountStream;
  int _initialStepCount = 0;
  int _currentStepCount = 0;
  DateTime _lastRecordedDate = DateTime.now();

  StepsCountNotifier(
    this._ref,
    this._getStepsData,
    this._addStepsEntry,
    this._userId,
  ) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final todayStepsData = await _getStepsData.call(_userId);
      _initialStepCount = todayStepsData?.steps ?? 0;
      _currentStepCount = _initialStepCount;

      _startListening();
      state = AsyncValue.data(_currentStepCount);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _startListening() {
    _stepCountStream = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: true,
    );
  }

  void _onStepCount(StepCount event) {
    final now = DateTime.now();
    if (!_isSameDay(now, _lastRecordedDate)) {
      // Reset daily step count at midnight
      _initialStepCount = event.steps;
      _currentStepCount = 0;
      _lastRecordedDate = now;
    } else {
      _currentStepCount = event.steps - _initialStepCount;
    }

    state = AsyncValue.data(_currentStepCount);
    _addStepsEntry.call(_userId, _currentStepCount);
  }

  void _onStepCountError(error) {
    state = AsyncValue.error(error, StackTrace.current);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Add this method to allow manual step updates
  Future<void> addSteps(int steps) async {
    try {
      state = const AsyncValue.loading();
      _currentStepCount = steps;
      await _addStepsEntry.call(_userId, _currentStepCount);
      state = AsyncValue.data(_currentStepCount);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  void dispose() {
    _stepCountStream.cancel();
    super.dispose();
  }
}

/// Notifier for steps goal
class StepsGoalNotifier extends StateNotifier<AsyncValue<int>> {
  final Ref _ref;
  final StepsRepositoryImpl _repository;
  final SetStepsGoal _setStepsGoal;
  final String _userId;

  StepsGoalNotifier(
    this._ref,
    this._repository,
    this._setStepsGoal,
    this._userId,
  ) : super(const AsyncValue.loading()) {
    _fetchGoal();
  }

  Future<void> _fetchGoal() async {
    try {
      state = const AsyncValue.loading();
      final goal = await _repository.getStepsGoal(_userId);
      state = AsyncValue.data(goal);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setGoal(int newGoal) async {
    try {
      await _setStepsGoal.call(_userId, newGoal);
      await _fetchGoal();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
