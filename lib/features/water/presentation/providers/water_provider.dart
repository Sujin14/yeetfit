import 'package:hooks_riverpod/hooks_riverpod.dart';

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

/// State Notifier for Water Data
final waterDataProvider = StateNotifierProvider.autoDispose
    .family<WaterDataNotifier, AsyncValue<WaterData?>, String>(
  (ref, userId) => WaterDataNotifier(
    ref,
    ref.read(getWaterDataProvider),
    userId,
  ),
);

/// State Notifier for Water Goal
final waterGoalProvider = StateNotifierProvider.autoDispose
    .family<WaterGoalNotifier, AsyncValue<int>, String>(
  (ref, userId) => WaterGoalNotifier(
    ref,
    ref.read(waterRepositoryProvider),
    userId,
  ),
);

/// Weekly Water Data Provider
final weeklyWaterDataProvider = FutureProvider.family<List<WaterData>, String>(
  (ref, userId) async {
    final asyncResult =
        await ref.read(getWeeklyWaterDataProvider).call(userId);
    return asyncResult.when(
      data: (data) => data,
      error: (e, _) => throw e,
      loading: () => [],
    );
  },
);

/// Notifier for fetching and updating water data
class WaterDataNotifier extends StateNotifier<AsyncValue<WaterData?>> {
  final Ref _ref;
  final GetWaterData _getWaterData;
  final String _userId;

  WaterDataNotifier(this._ref, this._getWaterData, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchWaterData();
  }

  Future<void> _fetchWaterData() async {
    try {
      state = const AsyncValue.loading();
      final waterData = await _getWaterData.call(_userId);
      state = AsyncValue.data(waterData);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addGlass() async {
    try {
      await _ref.read(addGlassProvider).call(_userId);
      await _fetchWaterData();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> removeGlass() async {
    try {
      await _ref.read(removeGlassProvider).call(_userId);
      await _fetchWaterData();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Notifier for fetching and setting water goal
class WaterGoalNotifier extends StateNotifier<AsyncValue<int>> {
  final Ref _ref;
  final WaterRepositoryImpl _repository;
  final String _userId;

  WaterGoalNotifier(this._ref, this._repository, this._userId)
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
      await _ref.read(setWaterGoalProvider).call(_userId, newGoal);
      await _fetchGoal();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
