import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/datasources/water_datasource.dart';
import '../../data/model/water_model.dart';
import '../../data/repositories/water_repository_impl.dart';
import '../../domain/usecases/add_glass.dart';
import '../../domain/usecases/remove_glass.dart';
import '../../domain/usecases/set_water_goal.dart';
import '../../domain/usecases/get_water_data.dart';
import '../../domain/usecases/get_weekly_water_data.dart';

/// Repository provider
final waterRepositoryProvider = Provider<WaterRepositoryImpl>(
  (ref) => WaterRepositoryImpl(WaterDataSource()),
);

/// UseCase providers
final addGlassProvider = Provider<AddGlass>(
  (ref) => AddGlass(ref.read(waterRepositoryProvider)),
);

final removeGlassProvider = Provider<RemoveGlass>(
  (ref) => RemoveGlass(ref.read(waterRepositoryProvider)),
);

final setWaterGoalProvider = Provider<SetWaterGoal>(
  (ref) => SetWaterGoal(ref.read(waterRepositoryProvider)),
);

final getWaterDataProvider = Provider<GetWaterData>(
  (ref) => GetWaterData(ref.read(waterRepositoryProvider)),
);

final getWeeklyWaterDataProvider = Provider<GetWeeklyWaterData>(
  (ref) => GetWeeklyWaterData(ref.read(waterRepositoryProvider)),
);

/// Provider for glasses consumed
final glassesConsumedProvider = StateNotifierProvider.autoDispose
    .family<GlassesConsumedNotifier, AsyncValue<int>, String>(
  (ref, userId) => GlassesConsumedNotifier(
    ref,
    ref.read(getWaterDataProvider),
    ref.read(addGlassProvider),
    ref.read(removeGlassProvider),
    userId,
  ),
);

/// Provider for water goal
final waterGoalProvider = StateNotifierProvider.autoDispose
    .family<WaterGoalNotifier, AsyncValue<int>, String>(
  (ref, userId) => WaterGoalNotifier(
    ref,
    ref.read(waterRepositoryProvider),
    ref.read(setWaterGoalProvider),
    userId,
  ),
);

/// Provider for daily progress color for a specific date
final dailyProgressColorProvider = Provider.autoDispose.family<Color, String>(
  (ref, userIdAndDate) {
    final parts = userIdAndDate.split('|');
    final userId = parts[0];
    final date = parts[1];
    final weeklyData = ref.watch(weeklyWaterDataProvider(userId)).value ?? [];
    final today = DateTime.now().toIso8601String().split('T')[0];
    final glassesConsumed = date == today
        ? ref.watch(glassesConsumedProvider(userId).select((value) => value.value ?? 0))
        : (weeklyData.firstWhere(
            (entry) => entry.date == date,
            orElse: () => WaterData(date: date, glassesConsumed: 0, goalGlasses: 8),
          ).glassesConsumed);
    final goalGlasses = date == today
        ? ref.watch(waterGoalProvider(userId).select((value) => value.value ?? 8))
        : (weeklyData.firstWhere(
            (entry) => entry.date == date,
            orElse: () => WaterData(date: date, glassesConsumed: 0, goalGlasses: 8),
          ).goalGlasses);
    final progress = goalGlasses > 0 ? glassesConsumed / goalGlasses : 0.0;

    if (progress >= 1.0) return AppTheme.colors['fullProgress']!;
    if (progress >= 0.75) return AppTheme.colors['ThreeQuarterProgress']!;
    if (progress >= 0.5) return AppTheme.colors['halfProgress']!;
    if (progress >= 0.25) return AppTheme.colors['QuarterProgress']!;
    return AppTheme.colors['noProgress']!;
  },
);

/// Weekly Water Data Provider
final weeklyWaterDataProvider = FutureProvider.family<List<WaterData>, String>(
  (ref, userId) async {
    final asyncResult = await ref.read(getWeeklyWaterDataProvider).call(userId);
    final weeklyData = asyncResult.when(
      data: (data) => data,
      error: (e, _) => throw e,
      loading: () => [],
    );
    // Ensure today's data is included, using current glassesConsumed and goalGlasses
    final today = DateTime.now().toIso8601String().split('T')[0];
    final glassesConsumed = ref.watch(glassesConsumedProvider(userId).select((value) => value.value ?? 0));
    final goalGlasses = ref.watch(waterGoalProvider(userId).select((value) => value.value ?? 8));
    final updatedData = weeklyData.where((data) => data.date != today).toList()
      ..add(WaterData(
        date: today,
        glassesConsumed: glassesConsumed,
        goalGlasses: goalGlasses,
      ));
    // Sort by date to ensure correct order
    updatedData.sort((a, b) => a.date.compareTo(b.date));
    return updatedData.cast<WaterData>();
  },
);

/// Notifier for glasses consumed
class GlassesConsumedNotifier extends StateNotifier<AsyncValue<int>> {
  final Ref _ref;
  final GetWaterData _getWaterData;
  final AddGlass _addGlass;
  final RemoveGlass _removeGlass;
  final String _userId;
  String? _lastDate; // Track the date of the last data fetch

  GlassesConsumedNotifier(
    this._ref,
    this._getWaterData,
    this._addGlass,
    this._removeGlass,
    this._userId,
  ) : super(const AsyncValue.loading()) {
    _fetchGlassesConsumed();
  }

  Future<void> _fetchGlassesConsumed() async {
    try {
      state = const AsyncValue.loading();
      final waterData = await _getWaterData.call(_userId);
      final newValue = waterData?.glassesConsumed ?? 0;
      final currentDate = waterData?.date ?? DateTime.now().toIso8601String().split('T')[0];
      _lastDate = currentDate; // Update the last date
      state = AsyncValue.data(newValue);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addGlass() async {
    try {
      await _addGlass.call(_userId);
      await _fetchGlassesConsumed();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> removeGlass() async {
    try {
      await _removeGlass.call(_userId);
      await _fetchGlassesConsumed();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  String? get lastDate => _lastDate; // Getter for lastDate
}

/// Notifier for water goal
class WaterGoalNotifier extends StateNotifier<AsyncValue<int>> {
  final Ref _ref;
  final WaterRepositoryImpl _repository;
  final SetWaterGoal _setWaterGoal;
  final String _userId;

  WaterGoalNotifier(this._ref, this._repository, this._setWaterGoal, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchGoal();
  }

  Future<void> _fetchGoal() async {
    try {
      state = const AsyncValue.loading();
      final goal = await _repository.getWaterGoal(_userId);
      state = AsyncValue.data(goal);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setGoal(int newGoal) async {
    try {
      await _setWaterGoal.call(_userId, newGoal);
      await _fetchGoal();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}