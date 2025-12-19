import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../../data/datasources/steps_datasource.dart';
import '../../data/model/steps_model.dart';
import '../../data/repositories/steps_repository_impl.dart';
import '../../domain/repositories/steps_repository.dart';
import '../../domain/usecases/add_steps_entry.dart';
import '../../domain/usecases/get_steps_data.dart';
import '../../domain/usecases/get_weekly_steps.dart';
import '../../domain/usecases/set_steps_goal.dart';
import '../../domain/usecases/update_daily_steps.dart';
import '../../../../shared/theme/theme.dart';

// Workmanager task IDs.
const String midnightResetTask = 'midnight_steps_reset_task';
const String periodicSaveTask = 'periodic_steps_save_task';

// Helper to get current total steps.
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
    return await completer.future.timeout(const Duration(seconds: 5));
  } catch (e) {
    rethrow;
  }
}

// Provider for Firebase Auth.
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

// Provider for current user ID.
final authUserIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser?.uid;
});

// Provider for steps repository.
final stepsRepositoryProvider = Provider<StepsRepository>(
  (ref) => StepsRepositoryImpl(StepsDataSource()),
);

// Use case providers.
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

final updateDailyStepsProvider = Provider<UpdateDailySteps>(
  (ref) => UpdateDailySteps(ref.read(stepsRepositoryProvider)),
);

// Provider for steps initializer (permissions, Workmanager).
final stepsInitializerProvider = Provider<StepsInitializer>(
  (ref) => StepsInitializer(ref),
);

// Steps count notifier with pedometer stream.
final stepsCountProvider = StateNotifierProvider.autoDispose
    .family<StepsCountNotifier, AsyncValue<int>, String>(
  (ref, userId) => StepsCountNotifier(ref, ref.read(getStepsDataProvider), userId),
);

// Steps count stream for real-time UI.
final stepsCountStreamProvider = StreamProvider.family<double, String>((ref, userId) {
  return ref.watch(stepsCountProvider(userId).notifier).stream.map(
    (asyncValue) => asyncValue.value?.toDouble() ?? 0.0,
  );
});

// Steps goal notifier.
final stepsGoalProvider = StateNotifierProvider.autoDispose
    .family<StepsGoalNotifier, AsyncValue<int>, String>(
  (ref, userId) => StepsGoalNotifier(
    ref,
    ref.read(stepsRepositoryProvider),
    ref.read(setStepsGoalProvider),
    userId,
  ),
);

// Calories burned provider.
final caloriesBurnedProvider = Provider.autoDispose.family<double, String>((ref, userId) {
  final steps = ref.watch(stepsCountProvider(userId).select((value) => value.value ?? 0));
  return steps * 0.04;
});

// Goal calories provider.
final goalCaloriesProvider = Provider.autoDispose.family<double, String>((ref, userId) {
  final goalSteps = ref.watch(stepsGoalProvider(userId).select((value) => value.value ?? 10000));
  return goalSteps * 0.04;
});

// Daily steps progress color.
final dailyStepsProgressColorProvider = Provider.autoDispose.family<Color, String>((ref, userIdAndDate) {
  final parts = userIdAndDate.split('|');
  final userId = parts[0];
  final date = parts[1];
  final weeklyData = ref.watch(weeklyStepsDataProvider(userId)).value ?? [];
  final today = DateTime.now().toIso8601String().split('T')[0];
  final steps = date == today
      ? ref.watch(stepsCountProvider(userId).select((value) => value.value ?? 0))
      : (weeklyData.firstWhere(
          (entry) => entry.date == date,
          orElse: () => StepsData(date: date, steps: 0, goalSteps: 10000, caloriesBurned: 0.0),
        ).steps);
  final goalSteps = date == today
      ? ref.watch(stepsGoalProvider(userId).select((value) => value.value ?? 10000))
      : (weeklyData.firstWhere(
          (entry) => entry.date == date,
          orElse: () => StepsData(date: date, steps: 0, goalSteps: 10000, caloriesBurned: 0.0),
        ).goalSteps);
  final progress = goalSteps > 0 ? steps / goalSteps : 0.0;

  if (progress >= 1.0) return AppTheme.colors['fullProgress']!;
  if (progress > 0.5) return AppTheme.colors['halfProgress']!;
  if (progress >= 0.25) return AppTheme.colors['quarterProgress']!;
  return AppTheme.colors['noProgress']!;
});

// Weekly steps data.
final weeklyStepsDataProvider = FutureProvider.autoDispose.family<List<StepsData>, String>(
  (ref, userId) async {
    final asyncResult = await ref.read(getWeeklyStepsDataProvider).call(userId);
    return asyncResult;
  },
);

// Chart data (merged with today).
final chartDataProvider = Provider.autoDispose.family<List<StepsData>, String>((ref, userId) {
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

// Chart configuration.
final chartConfigProvider = Provider.autoDispose.family<Map<String, dynamic>, String>((ref, userId) {
  final chartData = ref.watch(chartDataProvider(userId));
  final maxGoal = chartData.map((e) => e.goalSteps.toDouble()).reduce((a, b) => a > b ? a : b);
  final interval = _calculateInterval(maxGoal);
  return {'maxY': (maxGoal * 1.2).ceilToDouble(), 'interval': interval};
});

double _calculateInterval(double maxGoal) {
  if (maxGoal <= 5000) return 1000;
  if (maxGoal <= 10000) return 2000;
  if (maxGoal <= 20000) return 5000;
  return 10000;
}

String formatStepCount(double value) {
  if (value >= 1000) {
    final thousands = (value / 1000).floor();
    return '${thousands}k';
  }
  return value.toInt().toString();
}

/// Initial value for goal dialog.
final stepsGoalInitialValueProvider = Provider.autoDispose.family<String, String>((ref, userId) {
  final goalSteps = ref.watch(stepsGoalProvider(userId)).value ?? 10000;
  return goalSteps.toString();
});

// Success message.
final stepsSuccessMessageProvider = Provider.autoDispose.family<String, String>((ref, goal) {
  return 'You reached your step goal of $goal steps — keep moving! 🚶';
});

// Notifier for steps count with pedometer.
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

  StepsCountNotifier(this._ref, this._getStepsData, this._userId) : super(const AsyncValue.loading()) {
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
        _currentStepCount = currentTotal - baseline;
        _initialStepCount = baseline;
      } else {
        if (baseline != null && baselineDateStr != null) {
          final prevDate = baselineDateStr;
          final prevDailySteps = currentTotal - baseline;
          if (prevDailySteps > 0) {
            try {
              final goalSteps = await _getUserStepsGoal(prevDate);
              await _saveSteps(prevDate, prevDailySteps);
            } catch (e) {
              // Ignore save errors
            }
          }
        }
        _currentStepCount = 0;
        _initialStepCount = currentTotal;
        await prefs.setString('$_baselineStepsKey$_userId', currentTotal.toString());
        await prefs.setString('$_baselineDateKey$_userId', today);
        _lastResetTime = DateTime(now.year, now.month, now.day);
      }

      final todayStepsData = await _getStepsData.call(_userId, today);
      _currentStepCount = todayStepsData?.steps ?? _currentStepCount;

      if (_isPedometerActive) _startListening();
      await _ref.read(stepsRepositoryProvider).syncLocalData(_userId);
      state = AsyncValue.data(_currentStepCount);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      _isPedometerActive = false;
      state = AsyncValue.error('Permission denied for step tracking', StackTrace.current);
    }
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
      final prevDate = _lastResetTime.toIso8601String().split('T')[0];
      if (_currentStepCount > 0) {
        try {
          final goalSteps = await _getUserStepsGoal(prevDate);
          await _saveSteps(prevDate, _currentStepCount);
        } catch (e) {
          // Ignore
        }
      }
      _initialStepCount = event.steps;
      _currentStepCount = 0;
      _lastResetTime = DateTime(now.year, now.month, now.day);
      await prefs.setString('$_baselineStepsKey$_userId', event.steps.toString());
      await prefs.setString('$_baselineDateKey$_userId', today);
    } else {
      final newSteps = event.steps - _initialStepCount;
      if (newSteps >= 0) {
        _currentStepCount = newSteps;
      } else {
        final today = now.toIso8601String().split('T')[0];
        final todayStepsData = await _getStepsData.call(_userId, today);
        final savedSteps = todayStepsData?.steps ?? 0;
        _initialStepCount = event.steps - savedSteps;
        _currentStepCount = savedSteps;
      }
    }

    if (_currentStepCount % 100 == 0 && _currentStepCount > 0) {
      final today = now.toIso8601String().split('T')[0];
      await _saveSteps(today, _currentStepCount);
    }

    state = AsyncValue.data(_currentStepCount);
  }

  void _onStepCountError(error) {
    _isPedometerActive = false;
    state = AsyncValue.error(error, StackTrace.current);
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

  Future<int> _getUserStepsGoal(String date) async {
    return await _ref.read(stepsRepositoryProvider).getStepsGoal(_userId, date);
  }

  Future<void> _saveSteps(String date, int steps) async {
    await _ref.read(updateDailyStepsProvider).call(_userId, date, steps);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stepCountStream?.cancel();
    super.dispose();
  }
}

// Notifier for steps goal.
class StepsGoalNotifier extends StateNotifier<AsyncValue<int>> {
  final Ref _ref;
  final StepsRepository _repository;
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

// Initializer for steps (permissions, Workmanager).
class StepsInitializer {
  final Ref _ref;

  StepsInitializer(this._ref);

  Future<void> initStepCounter() async {
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      return;
    }

    try {
      await getCurrentTotalSteps();
    } catch (e) {
      // Ignore init errors
    }
  }

  void scheduleWorkmanagerTask(String userId) {
    final midnightName = 'midnight_$userId';
    final periodicName = 'periodic_$userId';

    Workmanager().registerPeriodicTask(
      midnightName,
      midnightResetTask,
      inputData: {'userId': userId},
      frequency: const Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
      constraints: Constraints(networkType: NetworkType.connected),
    );

    Workmanager().registerPeriodicTask(
      periodicName,
      periodicSaveTask,
      inputData: {'userId': userId},
      frequency: const Duration(hours: 1),
      initialDelay: const Duration(minutes: 5),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  Duration _calculateInitialDelay() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }
}

/// Background Workmanager callback (entry-point).
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
        if (baselineDateStr == today) {
          final dailySteps = currentTotal - baseline;
          final goalSteps = await dataSource.getStepsGoal(userId, today);
          await dataSource.addStepsEntry(userId, today, dailySteps, goalSteps, dailySteps * 0.04);
        }
        return true;
      }

      if (task == midnightResetTask) {
        if (baselineDateStr != today) {
          final prevDate = baselineDate.toIso8601String().split('T')[0];
          final prevDaily = currentTotal - baseline;
          if (prevDaily > 0) {
            final goalSteps = await dataSource.getStepsGoal(userId, prevDate);
            await dataSource.addStepsEntry(userId, prevDate, prevDaily, goalSteps, prevDaily * 0.04);
          }
        }
        await prefs.setString('${StepsCountNotifier._baselineStepsKey}$userId', currentTotal.toString());
        await prefs.setString('${StepsCountNotifier._baselineDateKey}$userId', today);
        return true;
      }
    } catch (e) {
      // Ignore background errors
    }
    return false;
  });
}