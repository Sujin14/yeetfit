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
import '../../domain/usecases/get_weekly_steps.dart';
import '../../domain/usecases/set_steps_goal.dart';
import '../../../../shared/theme/theme.dart';

// Workmanager task identifier
const String midnightResetTask = 'midnight_steps_reset_task';

// Repository provider
final stepsRepositoryProvider = Provider<StepsRepositoryImpl>(
  (ref) => StepsRepositoryImpl(StepsDataSource()),
);

// UseCase providers
final setStepsGoalProvider = Provider<SetStepsGoal>(
  (ref) => SetStepsGoal(ref.read(stepsRepositoryProvider)),
);

final getStepsDataProvider = Provider<GetStepsData>(
  (ref) => GetStepsData(ref.read(stepsRepositoryProvider)),
);

final getWeeklyStepsDataProvider = Provider<GetWeeklyStepsData>(
  (ref) => GetWeeklyStepsData(ref.read(stepsRepositoryProvider)),
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
      final stepCount = await Pedometer.stepCountStream.first.timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Pedometer initialization timeout'),
      );
      if (kDebugMode) print('Steps detected: ${stepCount.steps}');
    } catch (e) {
      if (kDebugMode) print('Error initializing step counter: $e');
    }
  }

  void scheduleWorkmanagerTask(String userId) {
    Workmanager().registerPeriodicTask(
      midnightResetTask,
      midnightResetTask,
      inputData: {'userId': userId},
      frequency: const Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
      constraints: Constraints(networkType: NetworkType.connected),
    );
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
  static const String _lastStepCountKey = 'last_step_count';
  static const String _lastStepDateKey = 'last_step_date';
  static const String _lastResetTimeKey = 'last_reset_time';
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
      final prefs = await SharedPreferences.getInstance();
      final lastStepDate = prefs.getString('$_lastStepDateKey$_userId');
      final lastStepCount = prefs.getInt('$_lastStepCountKey$_userId') ?? 0;
      final lastResetTimeString = prefs.getString('$_lastResetTimeKey$_userId');
      _lastResetTime = lastResetTimeString != null
          ? DateTime.parse(lastResetTimeString)
          : DateTime.now();
      final today = DateTime.now().toIso8601String().split('T')[0];

      if (lastStepDate != today && lastStepDate != null && lastStepCount > 0) {
        final goalSteps = await _getUserStepsGoal();
        await _saveSteps(lastStepDate, lastStepCount, goalSteps);
        await prefs.setInt('$_lastStepCountKey$_userId', 0);
        await prefs.setString('$_lastStepDateKey$_userId', today);
        _lastResetTime = DateTime(now.year, now.month, now.day);
        await prefs.setString('$_lastResetTimeKey$_userId', _lastResetTime.toIso8601String());
      }

      final initialStepCount = await _getInitialStepCount();
      if (initialStepCount != null) {
        _initialStepCount = initialStepCount;
      } else {
        _isPedometerActive = false;
        state = AsyncValue.error('Failed to initialize pedometer', StackTrace.current);
        return;
      }

      final todayStepsData = await _getStepsData.call(_userId);
      _currentStepCount = todayStepsData?.steps ?? lastStepCount;

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
      _stepCountStream?.cancel();
      if (kDebugMode) print('StepsCountNotifier: App paused, pausing pedometer stream for userId=$_userId');
    } else if (state == AppLifecycleState.resumed) {
      if (_isPedometerActive) {
        _startListening();
        if (kDebugMode) print('StepsCountNotifier: App resumed, restarting pedometer stream for userId=$_userId');
      }
    }
  }

  Future<int> _getUserStepsGoal() async {
    return await _ref.read(stepsRepositoryProvider).getStepsGoal(_userId);
  }

  Future<void> _saveSteps(String date, int steps, int goalSteps) async {
    await _ref.read(stepsRepositoryProvider).addStepsEntry(_userId, steps);
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      if (kDebugMode) print('StepsCountNotifier: Activity recognition permission not granted');
      _isPedometerActive = false;
      state = AsyncValue.error('Permission denied for step tracking', StackTrace.current);
    }
  }

  Future<int?> _getInitialStepCount() async {
    try {
      final completer = Completer<int>();
      final subscription = Pedometer.stepCountStream.listen(
        (event) => completer.complete(event.steps),
        onError: (error) => completer.completeError(error),
        cancelOnError: true,
      );
      final steps = await completer.future.timeout(const Duration(seconds: 5));
      await subscription.cancel();
      return steps;
    } catch (e) {
      if (kDebugMode) print('StepsCountNotifier: Failed to get initial step count: $e');
      return null;
    }
  }

  Future<void> _initializeWorkmanager() async {
    await Workmanager().registerPeriodicTask(
      midnightResetTask,
      midnightResetTask,
      frequency: const Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
      constraints: Constraints(networkType: NetworkType.connected),
      inputData: {'userId': _userId},
    );
  }

  Duration _calculateInitialDelay() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
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
      final prevSteps = _currentStepCount;
      final prevDate = _lastResetTime.toIso8601String().split('T')[0];
      if (prevSteps > 0) {
        final goalSteps = await _getUserStepsGoal();
        await _saveSteps(prevDate, prevSteps, goalSteps);
      }
      _initialStepCount = event.steps;
      _currentStepCount = 0;
      _lastResetTime = DateTime(now.year, now.month, now.day);
      await prefs.setString('$_lastResetTimeKey$_userId', _lastResetTime.toIso8601String());
      await prefs.setInt('$_lastStepCountKey$_userId', 0);
      await prefs.setString('$_lastStepDateKey$_userId', today);
    } else {
      final newSteps = event.steps - _initialStepCount;
      if (newSteps >= 0) {
        _currentStepCount = newSteps;
      } else {
        if (kDebugMode) print('StepsCountNotifier: Reset detected, recalibrating initial step count');
        final todayStepsData = await _getStepsData.call(_userId);
        _initialStepCount = event.steps - (todayStepsData?.steps ?? 0);
        _currentStepCount = todayStepsData?.steps ?? 0;
      }
    }

    await prefs.setInt('$_lastStepCountKey$_userId', _currentStepCount);
    await prefs.setString('$_lastStepDateKey$_userId', today);

    if (_currentStepCount % 100 == 0 && _currentStepCount > 0) {
      final goalSteps = await _getUserStepsGoal();
      await _saveSteps(today, _currentStepCount, goalSteps);
    }

    state = AsyncValue.data(_currentStepCount);
  }

  void _onStepCountError(error) {
    if (kDebugMode) print('StepsCountNotifier: Pedometer error: $error');
    _isPedometerActive = false;
    state = AsyncValue.error(error, StackTrace.current);
    Future.delayed(const Duration(seconds: 5), () {
      if (_isPedometerActive) _startListening();
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> forceSyncSteps() async {
    try {
      state = const AsyncValue.loading();
      final goalSteps = await _getUserStepsGoal();
      await _saveSteps(DateTime.now().toIso8601String().split('T')[0], _currentStepCount, goalSteps);
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

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == midnightResetTask) {
      final userId = inputData?['userId'] as String?;
      if (userId == null) return false;

      final prefs = await SharedPreferences.getInstance();
      final lastStepCount = prefs.getInt('last_step_count$userId') ?? 0;
      final lastStepDate = prefs.getString('last_step_date$userId');
      final today = DateTime.now().toIso8601String().split('T')[0];

      if (lastStepDate != null && lastStepDate != today && lastStepCount > 0) {
        final dataSource = StepsDataSource();
        final goalSteps = await dataSource.getStepsGoal(userId, lastStepDate);
        await dataSource.addStepsEntry(
          userId,
          lastStepDate,
          lastStepCount,
          goalSteps,
          lastStepCount * 0.04,
        );
        await prefs.setInt('last_step_count$userId', 0);
        await prefs.setString('last_step_date$userId', today);
        await prefs.setString('last_reset_time$userId', DateTime.now().toIso8601String());
      }
      return true;
    }
    return false;
  });
}
