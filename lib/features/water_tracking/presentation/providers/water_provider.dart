import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/water_datasource.dart';
import '../../domain/entities/water_data.dart';
import '../../data/repositories/water_repository_impl.dart';
import '../../domain/repositories/water_repository.dart';

String _todayKey() => DateTime.now().toIso8601String().split('T')[0];

final waterRepositoryProvider = Provider<WaterRepository>(
  (ref) => WaterRepositoryImpl(WaterDataSource()),
);

/// Today's water document: glasses consumed and the daily goal.
final todayWaterProvider = AsyncNotifierProvider.autoDispose
    .family<TodayWaterNotifier, WaterData, String>(TodayWaterNotifier.new);

/// Last seven days of saved entries, fetched once per screen visit.
final waterHistoryProvider = FutureProvider.autoDispose
    .family<List<WaterData>, String>(
      (ref, userId) =>
          ref.read(waterRepositoryProvider).getWeeklyWaterData(userId),
    );

/// [waterHistoryProvider] with today's live entry merged in, sorted by date.
final weeklyWaterDataProvider = Provider.autoDispose
    .family<AsyncValue<List<WaterData>>, String>((ref, userId) {
      final today = ref.watch(todayWaterProvider(userId)).value;
      return ref
          .watch(waterHistoryProvider(userId))
          .whenData(
            (history) => [
              for (final entry in history)
                if (entry.date != today?.date) entry,
              ?today,
            ]..sort((a, b) => a.date.compareTo(b.date)),
          );
    });

// Navigation notifier for success page.
final waterTrackingNavigationProvider = NotifierProvider.autoDispose
    .family<WaterTrackingNavigationNotifier, bool, String>(
      WaterTrackingNavigationNotifier.new,
    );

class TodayWaterNotifier extends AsyncNotifier<WaterData> {
  final String userId;

  TodayWaterNotifier(this.userId);

  WaterRepository get _repository => ref.read(waterRepositoryProvider);

  @override
  Future<WaterData> build() => _fetch();

  Future<WaterData> _fetch() async {
    final waterData = await _repository.getWaterData(userId);
    return waterData ??
        WaterData(date: _todayKey(), glassesConsumed: 0, goalGlasses: 8);
  }

  // No loading reset: the screen keeps showing the last count while a
  // write's refresh is in flight instead of flashing its skeleton.
  Future<void> refresh() async {
    final result = await AsyncValue.guard(_fetch);
    if (ref.mounted) state = result;
  }

  Future<void> addGlass() => _writeThenRefresh(_repository.addGlass);

  Future<void> removeGlass() => _writeThenRefresh(_repository.removeGlass);

  Future<void> _writeThenRefresh(Future<void> Function(String) write) async {
    try {
      await write(userId);
      await refresh();
    } catch (e, stackTrace) {
      if (ref.mounted) state = AsyncError(e, stackTrace);
    }
  }
}

/// Flips to `true` when a glass added on this screen crosses the daily goal.
///
/// The provider is autoDispose and is recreated every time the screen opens,
/// so it must not fire just because the reloaded count is already at the
/// goal; only a live below → at-or-above transition counts.
class WaterTrackingNavigationNotifier extends Notifier<bool> {
  final String userId;
  int? _lastConsumed;
  String? _lastNavigatedDate;

  WaterTrackingNavigationNotifier(this.userId);

  @override
  bool build() {
    ref.listen<AsyncValue<WaterData>>(todayWaterProvider(userId), (_, next) {
      final water = next.value;
      // Loading/error states carry no count; keep the last known one.
      if (water == null) return;
      final previousConsumed = _lastConsumed;
      final consumed = water.glassesConsumed;
      final goal = water.goalGlasses;
      _lastConsumed = consumed;
      if (previousConsumed == null || goal <= 0) return;

      final today = _todayKey();
      if (previousConsumed < goal &&
          consumed >= goal &&
          _lastNavigatedDate != today) {
        _lastNavigatedDate = today;
        state = true;
      }
    });
    return false;
  }

  void reset() => state = false;
}

// Saves the daily water goal. `data(true)` once saved; errors carry a
// user-facing message.
final waterGoalControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WaterGoalController, bool, String>(WaterGoalController.new);

class WaterGoalController extends AsyncNotifier<bool> {
  final String userId;

  WaterGoalController(this.userId);

  @override
  FutureOr<bool> build() => false;

  Future<void> submit(String input) async {
    if (state.isLoading) return;
    final newGoal = int.tryParse(input.trim());
    if (newGoal == null || newGoal <= 0) {
      state = AsyncError('Please enter a valid number', StackTrace.current);
      return;
    }
    state = const AsyncLoading();
    try {
      await ref.read(waterRepositoryProvider).setWaterGoal(userId, newGoal);
      await ref.read(todayWaterProvider(userId).notifier).refresh();
      if (ref.mounted) state = const AsyncData(true);
    } catch (e, stackTrace) {
      if (ref.mounted) {
        state = AsyncError('Failed to save water goal: $e', stackTrace);
      }
    }
  }
}
