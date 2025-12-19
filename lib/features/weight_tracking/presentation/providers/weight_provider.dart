import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../data/datasources/weight_datasource.dart';
import '../../data/model/weight_model.dart';
import '../../data/repositories/weight_repository_impl.dart';
import '../../domain/repositories/weight_repository.dart';
import '../../domain/usecases/add_weight_entry.dart';
import '../../domain/usecases/get_weight_data.dart';
import '../../domain/usecases/get_weekly_weight_data.dart';
import '../../domain/usecases/set_weight_goal.dart';
import 'package:go_router/go_router.dart';

// Provider for Firebase Auth instance.
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

// Provider for current authenticated user ID (centralized).
final authUserIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser?.uid;
});

// Provider for weight repository.
final weightRepositoryProvider = Provider<WeightRepository>(
  (ref) => WeightRepositoryImpl(WeightDataSource()),
);

// Providers for use cases.
final addWeightEntryProvider = Provider<AddWeightEntry>(
  (ref) => AddWeightEntry(ref.read(weightRepositoryProvider)),
);

final setWeightGoalProvider = Provider<SetWeightGoal>(
  (ref) => SetWeightGoal(ref.read(weightRepositoryProvider)),
);

final getWeightDataProvider = Provider<GetWeightData>(
  (ref) => GetWeightData(ref.read(weightRepositoryProvider)),
);

final getWeeklyWeightDataProvider = Provider<GetWeeklyWeightData>(
  (ref) => GetWeeklyWeightData(ref.read(weightRepositoryProvider)),
);

// Today's weight data for user.
final currentWeightDataProvider = FutureProvider.family<WeightData?, String>(
  (ref, userId) async {
    return await ref.read(getWeightDataProvider).call(userId);
  },
);

// Notifier for current weight, with update and success nav listener.
final currentWeightProvider = StateNotifierProvider.autoDispose
    .family<CurrentWeightNotifier, AsyncValue<double>, String>(
  (ref, userId) => CurrentWeightNotifier(ref, userId),
);

// Notifier for weight goal.
final weightGoalProvider = StateNotifierProvider.autoDispose
    .family<WeightGoalNotifier, AsyncValue<WeightData>, String>(
  (ref, userId) => WeightGoalNotifier(
    ref,
    ref.read(weightRepositoryProvider),
    ref.read(setWeightGoalProvider),
    userId,
  ),
);

// Computed progress and color for UI.
final weightProgressProvider = Provider.autoDispose.family<Map<String, dynamic>, String>(
  (ref, userId) {
    final currentWeight = ref.watch(currentWeightProvider(userId).select((value) => value.value ?? 75.0));
    final goal = ref.watch(weightGoalProvider(userId).select((value) => value.value));
    final goalWeight = goal?.goalWeight ?? 70.0;
    final initialWeight = goal?.initialWeight ?? 75.0;
    final progress = initialWeight != goalWeight
        ? ((initialWeight - currentWeight) / (initialWeight - goalWeight)).clamp(0.0, 1.0)
        : 0.0;

    Color color;
    if (progress >= 1.0) {
      color =  AppTheme.colors['fullProgress']!;// Green
    } else if (progress > 0.5) {
      color = AppTheme.colors['halfProgress']!; // Yellow
    } else if (progress >= 0.25) {
      color = AppTheme.colors['quarterProgress']!; // Orange
    } else {
      color = AppTheme.colors['noProgress']!; // Red
    }
    return {'progress': progress, 'color': color};
  },
);

// Weekly weight data, merged with today.
final weeklyWeightDataProvider = FutureProvider.autoDispose.family<List<WeightData>, String>(
  (ref, userId) async {
    final weeklyData = await ref.read(getWeeklyWeightDataProvider).call(userId);
    final today = DateTime.now().toIso8601String().split('T')[0];
    final currentWeight = ref.watch(currentWeightProvider(userId).select((value) => value.value ?? 75.0));
    final goal = ref.watch(weightGoalProvider(userId).select((value) => value.value));

    final updatedData = weeklyData.where((data) => data.date != today).toList()
      ..add(WeightData(
        date: today,
        currentWeight: currentWeight,
        goalWeight: goal?.goalWeight ?? 70.0,
        initialWeight: goal?.initialWeight ?? 75.0,
        targetDate: goal?.targetDate,
      ));
    updatedData.sort((a, b) => a.date.compareTo(b.date));
    return updatedData;
  },
);

// Notifier for current weight updates.
class CurrentWeightNotifier extends StateNotifier<AsyncValue<double>> {
  final Ref _ref;
  final String _userId;

  CurrentWeightNotifier(this._ref, this._userId) : super(const AsyncValue.loading()) {
    _fetchWeight();
  }

  Future<void> _fetchWeight() async {
    try {
      state = const AsyncValue.loading();
      final weightData = await _ref.read(weightRepositoryProvider).getWeightData(_userId);
      final weight = weightData?.currentWeight ?? 75.0;
      state = AsyncValue.data(weight);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Updates weight and checks for goal achievement.
  Future<void> updateWeight(double currentWeight, BuildContext context) async {
    try {
      state = const AsyncValue.loading();
      final goal = await _ref.read(weightRepositoryProvider).getUserWeightGoal(_userId);

      await _ref.read(weightRepositoryProvider).updateWeight(
        _userId,
        currentWeight,
        goal?.goalWeight,
        goal?.initialWeight,
        goal?.targetDate,
      );

      state = AsyncValue.data(currentWeight);

      // Check if goal achieved and navigate.
      if (goal != null && (currentWeight - goal.goalWeight).abs() < 0.1) {
        final goalStr = goal.goalWeight.toStringAsFixed(1);
        if (context.mounted) {
          context.push('/weight-success/$goalStr');
        }
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Notifier for weight goal management.
class WeightGoalNotifier extends StateNotifier<AsyncValue<WeightData>> {
  final Ref _ref;
  final WeightRepository _repository;
  final SetWeightGoal _setWeightGoal;
  final String _userId;

  WeightGoalNotifier(this._ref, this._repository, this._setWeightGoal, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchGoal();
  }

  Future<void> _fetchGoal() async {
    try {
      state = const AsyncValue.loading();
      final goal = await _repository.getUserWeightGoal(_userId);
      final goalData = goal ?? WeightData(
        date: DateTime.now().toIso8601String().split('T')[0],
        currentWeight: 75.0,
        goalWeight: 70.0,
        initialWeight: 75.0,
      );
      state = AsyncValue.data(goalData);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setGoal(double goalWeight, double initialWeight, DateTime? targetDate) async {
    try {
      await _setWeightGoal.call(_userId, goalWeight, initialWeight, targetDate);
      await _fetchGoal();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}