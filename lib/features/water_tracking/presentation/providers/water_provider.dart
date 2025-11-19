import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/datasources/water_datasource.dart';
import '../../data/model/water_model.dart';
import '../../data/repositories/water_repository_impl.dart';
import '../../domain/repositories/water_repository.dart';
import '../../domain/usecases/add_glass.dart';
import '../../domain/usecases/get_water_data.dart';
import '../../domain/usecases/get_weekly_water_data.dart';
import '../../domain/usecases/remove_glass.dart';
import '../../domain/usecases/set_water_goal.dart';

// Provider for Firebase Auth instance.
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

// Provider for current authenticated user ID.
final authUserIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser?.uid;
});

// Provider for water repository.
final waterRepositoryProvider = Provider<WaterRepository>(
  (ref) => WaterRepositoryImpl(WaterDataSource()),
);

// Use case providers.
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

// Glasses consumed notifier.
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

// Water goal notifier.
final waterGoalProvider = StateNotifierProvider.autoDispose
    .family<WaterGoalNotifier, AsyncValue<int>, String>(
  (ref, userId) => WaterGoalNotifier(
    ref,
    ref.read(waterRepositoryProvider),
    ref.read(setWaterGoalProvider),
    userId,
  ),
);

// Daily progress color for date.
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

    return progress >= 1.0
        ? AppTheme.colors['fullProgress']!
        : progress >= 0.75
            ? AppTheme.colors['threeQuarterProgress']!
            : progress >= 0.5
                ? AppTheme.colors['halfProgress']!
                : progress >= 0.25
                    ? AppTheme.colors['quarterProgress']!
                    : AppTheme.colors['noProgress']!;
  },
);

// Weekly water data, merged with today.
final weeklyWaterDataProvider = FutureProvider.autoDispose.family<List<WaterData>, String>(
  (ref, userId) async {
    final weeklyData = await ref.read(getWeeklyWaterDataProvider).call(userId);
    final today = DateTime.now().toIso8601String().split('T')[0];
    final glassesConsumed = ref.watch(glassesConsumedProvider(userId).select((value) => value.value ?? 0));
    final goalGlasses = ref.watch(waterGoalProvider(userId).select((value) => value.value ?? 8));

    final updatedData = weeklyData.where((data) => data.date != today).toList()
      ..add(WaterData(
        date: today,
        glassesConsumed: glassesConsumed,
        goalGlasses: goalGlasses,
      ));
    updatedData.sort((a, b) => a.date.compareTo(b.date));
    return updatedData;
  },
);

// Navigation notifier for success page.
final waterTrackingNavigationProvider = StateNotifierProvider.autoDispose
    .family<WaterTrackingNavigationNotifier, bool, String>(
  (ref, userId) => WaterTrackingNavigationNotifier(ref, userId),
);

// Notifier for glasses consumed.
class GlassesConsumedNotifier extends StateNotifier<AsyncValue<int>> {
  final Ref _ref;
  final GetWaterData _getWaterData;
  final AddGlass _addGlass;
  final RemoveGlass _removeGlass;
  final String _userId;
  String? _lastDate;

  GlassesConsumedNotifier(this._ref, this._getWaterData, this._addGlass, this._removeGlass, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchGlassesConsumed();
  }

  Future<void> _fetchGlassesConsumed() async {
    try {
      state = const AsyncValue.loading();
      final waterData = await _getWaterData.call(_userId);
      final newValue = waterData?.glassesConsumed ?? 0;
      _lastDate = waterData?.date ?? DateTime.now().toIso8601String().split('T')[0];
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

  String? get lastDate => _lastDate;
}

// Notifier for water goal.
class WaterGoalNotifier extends StateNotifier<AsyncValue<int>> {
  final Ref _ref;
  final WaterRepository _repository;
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

// Notifier for success navigation.
class WaterTrackingNavigationNotifier extends StateNotifier<bool> {
  final Ref _ref;
  final String _userId;
  String? _lastNavigatedDate;

  WaterTrackingNavigationNotifier(this._ref, this._userId) : super(false) {
    _listenToGlassesConsumed();
  }

  void _listenToGlassesConsumed() {
    _ref.listen(glassesConsumedProvider(_userId), (previous, next) {
      final consumed = next.value ?? 0;
      final goal = _ref.read(waterGoalProvider(_userId)).value ?? 8;

      final today = DateTime.now().toIso8601String().split('T')[0];
      final lastDate = _ref.read(glassesConsumedProvider(_userId).notifier).lastDate;

      if (lastDate != today) {
        state = false;
        _lastNavigatedDate = null;
      }

      if (consumed == goal && !state && _lastNavigatedDate != today) {
        state = true;
        _lastNavigatedDate = today;
      }
    });
  }

  void reset() {
    state = false;
  }
}


// State provider for water goal dialog.
final waterGoalDialogStateProvider = StateProvider.autoDispose.family<WaterGoalDialogState, String>(
  (ref, userId) => WaterGoalDialogState(ref, userId),
);

// State for water goal dialog.
class WaterGoalDialogState {
  final Ref ref;
  final String userId;
  final TextEditingController controller;

  WaterGoalDialogState(this.ref, this.userId)
      : controller = TextEditingController(
          text: ref.read(waterGoalProvider(userId)).value?.toString() ?? '8',
        );

  void submitGoal(BuildContext context) {
    final newGoal = int.tryParse(controller.text);
    if (newGoal != null && newGoal > 0) {
      ref.read(waterGoalProvider(userId).notifier).setGoal(newGoal);
      if (context.mounted) context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
    }
  }

  void dispose() {
    controller.dispose();
  }
}