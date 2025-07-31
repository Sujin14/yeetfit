import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasource/sleep_data_source.dart';
import '../../data/model/sleep_model.dart';
import '../../data/repositories/sleep_repository_impl.dart';
import '../../domain/usecases/add_sleep_entry.dart';
import '../../domain/usecases/set_sleep_goal.dart';
import '../../domain/usecases/get_sleep_data.dart';
import '../../domain/usecases/get_weekly_sleep_data.dart';

/// Repository provider
final sleepRepositoryProvider = Provider<SleepRepositoryImpl>(
  (ref) => SleepRepositoryImpl(SleepDataSource()),
);

/// UseCase providers
final addSleepEntryProvider = Provider<AddSleepEntry>(
  (ref) => AddSleepEntry(ref.read(sleepRepositoryProvider)),
);

final setSleepGoalProvider = Provider<SetSleepGoal>(
  (ref) => SetSleepGoal(ref.read(sleepRepositoryProvider)),
);

final getSleepDataProvider = Provider<GetSleepData>(
  (ref) => GetSleepData(ref.read(sleepRepositoryProvider)),
);

final getWeeklySleepDataProvider = Provider<GetWeeklySleepData>(
  (ref) => GetWeeklySleepData(ref.read(sleepRepositoryProvider)),
);

/// Provider for sleep duration
final sleepDurationProvider = StateNotifierProvider.autoDispose
    .family<SleepDurationNotifier, AsyncValue<double>, String>(
  (ref, userId) => SleepDurationNotifier(
    ref,
    ref.read(getSleepDataProvider),
    ref.read(addSleepEntryProvider),
    userId,
  ),
);

/// Provider for sleep goal
final sleepGoalProvider = StateNotifierProvider.autoDispose
    .family<SleepGoalNotifier, AsyncValue<double>, String>(
  (ref, userId) => SleepGoalNotifier(
    ref,
    ref.read(sleepRepositoryProvider),
    ref.read(setSleepGoalProvider),
    userId,
  ),
);

/// Provider for sleep times (bedtime and wake-up time)
final sleepTimesProvider = StateNotifierProvider.autoDispose
    .family<SleepTimesNotifier, AsyncValue<Map<String, DateTime?>>, String>(
  (ref, userId) => SleepTimesNotifier(
    ref,
    ref.read(getSleepDataProvider),
    ref.read(addSleepEntryProvider),
    userId,
  ),
);

/// Provider for daily progress color
final dailySleepProgressColorProvider = Provider.autoDispose.family<Color, String>(
  (ref, userIdAndDate) {
    final parts = userIdAndDate.split('|');
    final userId = parts[0];
    final date = parts[1];
    final weeklyData = ref.watch(weeklySleepDataProvider(userId)).value ?? [];
    final today = DateTime.now().toIso8601String().split('T')[0];
    final duration = date == today
        ? ref.watch(sleepDurationProvider(userId).select((value) => value.value ?? 0.0))
        : (weeklyData.firstWhere(
            (entry) => entry.date == date,
            orElse: () => SleepData(date: date, duration: 0.0, goalHours: 8.0),
          ).duration);
    final goalHours = date == today
        ? ref.watch(sleepGoalProvider(userId).select((value) => value.value ?? 8.0))
        : (weeklyData.firstWhere(
            (entry) => entry.date == date,
            orElse: () => SleepData(date: date, duration: 0.0, goalHours: 8.0),
          ).goalHours);
    final progress = goalHours > 0 ? duration / goalHours : 0.0;

    if (progress >= 1.0) return const Color(0xFF4CAF50); // Green for 100%
    if (progress > 0.5) return const Color(0xFFFFEB3B); // Yellow for >50%
    if (progress >= 0.25) return const Color(0xFFFF9800); // Orange for ~50%
    return const Color(0xFFF44336); // Red for <25%
  },
);

/// Weekly Sleep Data Provider
final weeklySleepDataProvider = FutureProvider.family<List<SleepData>, String>(
  (ref, userId) async {
    final asyncResult = await ref.read(getWeeklySleepDataProvider).call(userId);
    final weeklyData = asyncResult.when(
      data: (data) => data,
      error: (e, _) => throw e,
      loading: () => [],
    );
    final today = DateTime.now().toIso8601String().split('T')[0];
    final duration = ref.watch(sleepDurationProvider(userId).select((value) => value.value ?? 0.0));
    final goalHours = ref.watch(sleepGoalProvider(userId).select((value) => value.value ?? 8.0));
    final bedtime = ref.watch(sleepTimesProvider(userId).select((value) => value.value?['bedtime']));
    final wakeUpTime = ref.watch(sleepTimesProvider(userId).select((value) => value.value?['wakeUpTime']));
    final updatedData = weeklyData.where((data) => data.date != today).toList()
      ..add(SleepData(
        date: today,
        bedtime: bedtime,
        wakeUpTime: wakeUpTime,
        duration: duration,
        goalHours: goalHours,
      ));
    updatedData.sort((a, b) => a.date.compareTo(b.date));
    return updatedData.cast<SleepData>();
  },
);

/// Notifier for sleep duration
class SleepDurationNotifier extends StateNotifier<AsyncValue<double>> {
  final Ref _ref;
  final GetSleepData _getSleepData;
  final AddSleepEntry _addSleepEntry;
  final String _userId;

  SleepDurationNotifier(this._ref, this._getSleepData, this._addSleepEntry, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchSleepDuration();
  }

  Future<void> _fetchSleepDuration() async {
    try {
      state = const AsyncValue.loading();
      final sleepData = await _getSleepData.call(_userId);
      state = AsyncValue.data(sleepData?.duration ?? 0.0);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateDuration(DateTime bedtime, DateTime wakeUpTime, double duration) async {
    try {
      state = const AsyncValue.loading();
      await _addSleepEntry.call(_userId, bedtime, wakeUpTime, duration);
      state = AsyncValue.data(duration);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Notifier for sleep goal
class SleepGoalNotifier extends StateNotifier<AsyncValue<double>> {
  final Ref _ref;
  final SleepRepositoryImpl _repository;
  final SetSleepGoal _setSleepGoal;
  final String _userId;

  SleepGoalNotifier(this._ref, this._repository, this._setSleepGoal, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchGoal();
  }

  Future<void> _fetchGoal() async {
    try {
      state = const AsyncValue.loading();
      final goal = await _repository.getSleepGoal(_userId);
      state = AsyncValue.data(goal);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setGoal(double newGoal) async {
    try {
      await _setSleepGoal.call(_userId, newGoal);
      await _fetchGoal();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Notifier for sleep times
class SleepTimesNotifier extends StateNotifier<AsyncValue<Map<String, DateTime?>>> {
  final Ref _ref;
  final GetSleepData _getSleepData;
  final AddSleepEntry _addSleepEntry;
  final String _userId;

  SleepTimesNotifier(this._ref, this._getSleepData, this._addSleepEntry, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchSleepTimes();
  }

  Future<void> _fetchSleepTimes() async {
    try {
      state = const AsyncValue.loading();
      final sleepData = await _getSleepData.call(_userId);
      state = AsyncValue.data({
        'bedtime': sleepData?.bedtime,
        'wakeUpTime': sleepData?.wakeUpTime,
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addSleepEntry(DateTime bedtime, DateTime wakeUpTime, double duration) async {
    try {
      await _addSleepEntry.call(_userId, bedtime, wakeUpTime, duration);
      await _fetchSleepTimes();
      // Update duration provider
      _ref.read(sleepDurationProvider(_userId).notifier).updateDuration(bedtime, wakeUpTime, duration);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}