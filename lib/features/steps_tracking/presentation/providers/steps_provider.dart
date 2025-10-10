import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/datasources/steps_datasource.dart';
import '../../data/model/steps_model.dart';
import '../../data/repositories/steps_repository_impl.dart';
import '../../domain/usecases/get_steps_data.dart';
import '../../domain/usecases/add_steps_entry.dart';
import '../../domain/usecases/get_weekly_steps.dart';
import '../../domain/usecases/set_steps_goal.dart';
import '../../domain/usecases/update_daily_steps.dart';
import '../../../../shared/theme/theme.dart';

// Workmanager task identifiers
const String midnightResetTask = 'midnight_steps_reset_task';
const String periodicSaveTask = 'periodic_steps_save_task';

// Helper to query current total steps (used in app and background)
Future<int> getCurrentTotalSteps() async {
  try {
    final completer = Completer<int>();
    StreamSubscription<StepCount>? sub;
    sub = Pedometer.stepCountStream.listen(
      (StepCount event) {
        sub?.cancel();
        completer.complete(event.steps);
      },
      onError: (error) {
        sub?.cancel();
        completer.completeError(error);
      },
      cancelOnError: true,
    );
    final steps = await completer.future.timeout(const Duration(seconds: 5));
    return steps;
  } catch (e) {
    if (kDebugMode) print('getCurrentTotalSteps failed: $e');
    rethrow;
  }
}

// Repository provider
final stepsRepositoryProvider = Provider<StepsRepositoryImpl>(
  (ref) => StepsRepositoryImpl(StepsDataSource()),
);

// UseCase providers
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

// Provider for update daily steps
final updateDailyStepsProvider = Provider<UpdateDailySteps>(
  (ref) => UpdateDailySteps(ref.read(stepsRepositoryProvider)),
);

// StepsInitializer for handling initialization and Workmanager scheduling
final stepsInitializerProvider = Provider<StepsInitializer>(
  (ref) => StepsInitializer(ref),
);

class StepsInitializer {
  final Ref _ref;

  StepsInitializer(this._ref);

  Future<void> initStepCounter() async {
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      if (kDebugMode) print('Step tracking permission not granted.');
      return;
    }

    try {
      // Initialize pedometer with a simple check to ensure it's accessible
      await getCurrentTotalSteps();
      if (kDebugMode) print('Pedometer initialized successfully');
    } catch (e) {
      if (kDebugMode) print('Error initializing step counter: $e');
    }
  }

  void scheduleWorkmanagerTask(String userId) {
    // Unique task names per user to avoid conflicts
    final midnightName = 'midnight_$userId';
    final periodicName = 'periodic_$userId';

    // Midnight reset (daily)
    Workmanager().registerPeriodicTask(
      midnightName,
      midnightResetTask,
      inputData: {'userId': userId},
      frequency: const Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
      constraints: Constraints(networkType: NetworkType.connected),
    );

    // Periodic save (hourly)
    Workmanager().registerPeriodicTask(
      periodicName,
      periodicSaveTask,
      inputData: {'userId': userId},
      frequency: const Duration(hours: 1),
      initialDelay: const Duration(minutes: 5),
      constraints: Constraints(networkType: NetworkType.connected),
    );

    if (kDebugMode) print('Workmanager tasks scheduled for user $userId');
  }

  Duration _calculateInitialDelay() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }
}

// Provider for steps count
final stepsCountProvider =
    StateNotifierProvider.autoDispose.family<StepsCountNotifier, AsyncValue<int>, String>(
  (ref, userId) => StepsCountNotifier(ref, ref.read(getStepsDataProvider), userId),
);

final stepsCountStreamProvider = StreamProvider.family<double, String>((ref, userId) {
  return ref.watch(stepsCountProvider(userId).notifier).stream.map(
        (asyncValue) => asyncValue.value?.toDouble() ?? 0.0,
      );
});
// Provider for steps goal
final stepsGoalProvider =
    StateNotifierProvider.autoDispose.family<StepsGoalNotifier, AsyncValue<int>, String>(
  (ref, userId) => StepsGoalNotifier(
    ref,
    ref.read(stepsRepositoryProvider),
    ref.read(setStepsGoalProvider),
    userId,
  ),
);

// Provider for calories burned
final caloriesBurnedProvider = Provider.autoDispose.family<double, String>((ref, userId) {
  final steps = ref.watch(stepsCountProvider(userId).select((value) => value.value ?? 0));
  return steps * 0.04; // 0.04 calories per step
});

// Provider for goal calories
final goalCaloriesProvider = Provider.autoDispose.family<double, String>((ref, userId) {
  final goalSteps = ref.watch(stepsGoalProvider(userId).select((value) => value.value ?? 10000));
  return goalSteps * 0.04; // 0.04 calories per step
});

// Provider for daily progress color
final dailyStepsProgressColorProvider =
    Provider.autoDispose.family<Color, String>((ref, userIdAndDate) {
  final parts = userIdAndDate.split('|');
  final userId = parts[0];
  final date = parts[1];
  final weeklyData = ref.watch(weeklyStepsDataProvider(userId)).value ?? [];
  final today = DateTime.now().toIso8601String().split('T')[0];
  final steps = date == today
      ? ref.watch(stepsCountProvider(userId).select((value) => value.value ?? 0))
      : (weeklyData
              .firstWhere(
                (entry) => entry.date == date,
                orElse: () => StepsData(date: date, steps: 0, goalSteps: 10000, caloriesBurned: 0.0),
              )
              .steps);
  final goalSteps = date == today
      ? ref.watch(stepsGoalProvider(userId).select((value) => value.value ?? 10000))
      : (weeklyData
              .firstWhere(
                (entry) => entry.date == date,
                orElse: () => StepsData(date: date, steps: 0, goalSteps: 10000, caloriesBurned: 0.0),
              )
              .goalSteps);
  final progress = goalSteps > 0 ? steps / goalSteps : 0.0;

  if (progress >= 1.0) return AppTheme.colors['fullProgress']!;
  if (progress > 0.5) return AppTheme.colors['halfProgress']!;
  if (progress >= 0.25) return AppTheme.colors['quarterProgress']!;
  return AppTheme.colors['noProgress']!;
});

// Weekly Steps Data Provider
final weeklyStepsDataProvider = FutureProvider.family<List<StepsData>, String>((ref, userId) async {
  final asyncResult = await ref.read(getWeeklyStepsDataProvider).call(userId);
  return asyncResult.when(
    data: (data) => data,
    error: (e, _) => throw e,
    loading: () => [],
  );
});

// Chart Data Provider
final chartDataProvider = Provider.family<List<StepsData>, String>((ref, userId) {
  final weeklyData = ref.watch(weeklyStepsDataProvider(userId)).value ?? [];
  final today = DateTime.now().toIso8601String().split('T')[0];
  final todaySteps = ref.watch(stepsCountProvider(userId)).value ?? 0;
  final todayGoal = ref.watch(stepsGoalProvider(userId)).value ?? 10000;
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  return List.generate(7, (index) {
    final date = startOfWeek.add(Duration(days: index));
    final dateString = date.toIso8601String().split('T')[0];
    if (dateString == today) {
      return StepsData(
        date: dateString,
        steps: todaySteps,
        goalSteps: todayGoal,
        caloriesBurned: todaySteps * 0.04,
      );
    }
    return weeklyData.firstWhere(
      (entry) => entry.date == dateString,
      orElse: () => StepsData(date: dateString, steps: 0, goalSteps: 10000, caloriesBurned: 0.0),
    );
  });
});

// Chart Configuration Provider
final chartConfigProvider = Provider.family<Map<String, dynamic>, String>((ref, userId) {
  final chartData = ref.watch(chartDataProvider(userId));
  final maxGoal = chartData.map((e) => e.goalSteps.toDouble()).reduce((a, b) => a > b ? a : b);
  final maxY = (maxGoal * 1.2).ceilToDouble();
  final interval = _calculateInterval(maxGoal);
  return {'maxY': maxY, 'interval': interval};
});

// Calculate dynamic interval based on max goal
double _calculateInterval(double maxGoal) {
  if (maxGoal <= 5000) return 1000;
  if (maxGoal <= 10000) return 2000;
  if (maxGoal <= 20000) return 5000;
  return 10000;
}

// Format step count as 1k, 2k, 5k, 10k, etc.
String formatStepCount(double value) {
  if (value >= 1000) {
    final thousands = (value / 1000).floor();
    return '${thousands}k';
  }
  return value.toInt().toString();
}

// Provider for StepsGoalDialog initial value
final stepsGoalInitialValueProvider = Provider.family<String, String>((ref, userId) {
  final goalSteps = ref.watch(stepsGoalProvider(userId)).value ?? 10000;
  return goalSteps.toString();
});

// Provider for StepsSuccessPage message
final stepsSuccessMessageProvider = Provider.family<String, String>((ref, goal) {
  return 'You reached your step goal of $goal steps — keep moving! 🚶';
});

class StepsCountNotifier extends StateNotifier<AsyncValue<int>> with WidgetsBindingObserver {
  final Ref _ref;
  final GetStepsData _getStepsData;
  final String _userId;

  StreamSubscription<StepCount>? _stepCountStream;
  int _initialStepCount = 0;
  int _currentStepCount = 0;
  DateTime _lastResetTime = DateTime.now();
  static const String _baselineStepsKey = 'baseline_steps';
  static const String _baselineDateKey = 'baseline_date';
  bool _isPedometerActive = true;

  StepsCountNotifier(this._ref, this._getStepsData, this._userId)
      : super(const AsyncValue.loading()) {
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {
    try {
      await _requestPermissions();
      await _initializeWorkmanager();
      final now = DateTime.now();
      final today = now.toIso8601String().split('T')[0];
      final prefs = await SharedPreferences.getInstance();
      final baselineStr = prefs.getString('$_baselineStepsKey$_userId');
      final baselineDateStr = prefs.getString('$_baselineDateKey$_userId');
      final baseline = baselineStr != null ? int.tryParse(baselineStr) : null;
      final baselineDate = baselineDateStr != null ? DateTime.parse(baselineDateStr) : null;
      _lastResetTime = baselineDate ?? DateTime(now.year, now.month, now.day);

      final currentTotal = await getCurrentTotalSteps();

      if (baseline != null && baselineDateStr == today) {
        // Same day: Compute from baseline
        _currentStepCount = currentTotal - baseline;
        _initialStepCount = baseline;
      } else {
        // New day or no baseline: Reset (midnight task should handle, but safe-guard)
        if (kDebugMode) print('StepsCountNotifier: New day detected on init, resetting baseline');
        _currentStepCount = 0;
        _initialStepCount = currentTotal;
        await prefs.setString('$_baselineStepsKey$_userId', currentTotal.toString());
        await prefs.setString('$_baselineDateKey$_userId', today);
        _lastResetTime = DateTime(now.year, now.month, now.day);
      }

      final todayStepsData = await _getStepsData.call(_userId, today);
      // Override with computed if local outdated
      _currentStepCount = todayStepsData?.steps ?? _currentStepCount;

      if (_isPedometerActive) _startListening();
      await _ref.read(stepsRepositoryProvider).syncLocalData(_userId);
      state = AsyncValue.data(_currentStepCount);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Don't cancel stream on pause—keep listening for background (plugin handles)
      if (kDebugMode) print('StepsCountNotifier: App paused, stream continues for background');
    } else if (state == AppLifecycleState.resumed) {
      if (_isPedometerActive) {
        _startListening();
        if (kDebugMode) print('StepsCountNotifier: App resumed, ensuring stream active');
      }
    }
  }

  Future<int> _getUserStepsGoal(String date) async {
    return await _ref.read(stepsRepositoryProvider).getStepsGoal(_userId, date);
  }

  Future<void> _saveSteps(String date, int steps) async {
    await _ref.read(updateDailyStepsProvider).call(_userId, date, steps);
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      if (kDebugMode) print('StepsCountNotifier: Activity recognition permission not granted');
      _isPedometerActive = false;
      state = AsyncValue.error('Permission denied for step tracking', StackTrace.current);
    }
  }

  Future<int> _getInitialStepCount() async {
    return await getCurrentTotalSteps();
  }

  Future<void> _initializeWorkmanager() async {
    final initializer = _ref.read(stepsInitializerProvider);
    initializer.scheduleWorkmanagerTask(_userId);
  }

  void _startListening() {
    _stepCountStream?.cancel();
    if (!_isPedometerActive) return;

    _stepCountStream = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: false,
    );
  }

  void _onStepCount(StepCount event) async {
    if (!_isPedometerActive) return;

    final now = DateTime.now();
    final today = now.toIso8601String().split('T')[0];
    final prefs = await SharedPreferences.getInstance();

    if (!_isSameDay(now, _lastResetTime)) {
      // New day: Save previous day's final steps
      final prevDate = _lastResetTime.toIso8601String().split('T')[0];
      if (_currentStepCount > 0) {
        final goalSteps = await _getUserStepsGoal(prevDate);
        await _saveSteps(prevDate, _currentStepCount);
      }
      // Reset baseline to current total
      _initialStepCount = event.steps;
      _currentStepCount = 0;
      _lastResetTime = DateTime(now.year, now.month, now.day);
      await prefs.setString('$_baselineStepsKey$_userId', event.steps.toString());
      await prefs.setString('$_baselineDateKey$_userId', today);
      if (kDebugMode) print('StepsCountNotifier: New day reset, baseline set to ${event.steps}');
    } else {
      final newSteps = event.steps - _initialStepCount;
      if (newSteps >= 0) {
        _currentStepCount = newSteps;
      } else {
        // Recalibrate on reset (rare)
        if (kDebugMode) print('StepsCountNotifier: Sensor reset detected, recalibrating');
        final today = now.toIso8601String().split('T')[0];
        final todayStepsData = await _getStepsData.call(_userId, today);
        final savedSteps = todayStepsData?.steps ?? 0;
        _initialStepCount = event.steps - savedSteps;
        _currentStepCount = savedSteps;
      }
    }

    // No need to save prefs for count (computed from baseline); save to DB every 100 steps
    if (_currentStepCount % 100 == 0 && _currentStepCount > 0) {
      await _saveSteps(today, _currentStepCount);
    }

    state = AsyncValue.data(_currentStepCount);
  }

  void _onStepCountError(error) {
    if (kDebugMode) print('StepsCountNotifier: Pedometer error: $error');
    _isPedometerActive = false;
    state = AsyncValue.error(error, StackTrace.current);
    // Retry after delay
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _isPedometerActive) _startListening();
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> forceSyncSteps() async {
    try {
      state = const AsyncValue.loading();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final goalSteps = await _getUserStepsGoal(today);
      await _saveSteps(today, _currentStepCount);
      await _ref.read(stepsRepositoryProvider).syncLocalData(_userId);
      state = AsyncValue.data(_currentStepCount);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void togglePedometer(bool enable) {
    _isPedometerActive = enable;
    if (enable) {
      _startListening();
    } else {
      _stepCountStream?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stepCountStream?.cancel();
    super.dispose();
  }
}

class StepsGoalNotifier extends StateNotifier<AsyncValue<int>> {
  final Ref _ref;
  final StepsRepositoryImpl _repository;
  final SetStepsGoal _setStepsGoal;
  final String _userId;

  StepsGoalNotifier(this._ref, this._repository, this._setStepsGoal, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchGoal();
  }

  Future<void> _fetchGoal() async {
    try {
      state = const AsyncValue.loading();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final goal = await _repository.getStepsGoal(_userId, today);
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

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final userId = inputData?['userId'] as String?;
    if (userId == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final dataSource = StepsDataSource();
    final today = DateTime.now().toIso8601String().split('T')[0];

    try {
      final currentTotal = await getCurrentTotalSteps();
      final baselineStr = prefs.getString('${StepsCountNotifier._baselineStepsKey}$userId');
      final baselineDateStr = prefs.getString('${StepsCountNotifier._baselineDateKey}$userId');
      final baseline = baselineStr != null ? int.parse(baselineStr) : 0;
      final baselineDate = baselineDateStr != null ? DateTime.parse(baselineDateStr) : DateTime.now();

      if (task == periodicSaveTask) {
        // Periodic: Save current daily for today
        if (baselineDateStr == today) {
          final dailySteps = currentTotal - baseline;
          final goalSteps = await dataSource.getStepsGoal(userId, today);
          await dataSource.addStepsEntry(
            userId,
            today,
            dailySteps,
            goalSteps,
            dailySteps * 0.04,
          );
          if (kDebugMode) print('Background periodic save: $dailySteps steps for $today');
        }
        return true;
      }

      if (task == midnightResetTask) {
        // Midnight: Reset baseline (periodic handles save)
        if (baselineDateStr != today) {
          // Ensure previous day saved (fallback)
          final prevDate = baselineDate.toIso8601String().split('T')[0];
          final prevDaily = currentTotal - baseline;
          if (prevDaily > 0) {
            final goalSteps = await dataSource.getStepsGoal(userId, prevDate);
            await dataSource.addStepsEntry(
              userId,
              prevDate,
              prevDaily,
              goalSteps,
              prevDaily * 0.04,
            );
          }
        }
        // Set new baseline
        await prefs.setString('${StepsCountNotifier._baselineStepsKey}$userId', currentTotal.toString());
        await prefs.setString('${StepsCountNotifier._baselineDateKey}$userId', today);
        if (kDebugMode) print('Background midnight reset: Baseline set to $currentTotal for $today');
        return true;
      }
    } catch (e) {
      if (kDebugMode) print('Background task error: $e');
    }
    return false;
  });
}