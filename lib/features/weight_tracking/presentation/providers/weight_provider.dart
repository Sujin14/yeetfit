import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/weight_datasource.dart';
import '../../data/model/weight_model.dart';
import '../../data/repositories/weight_repository_impl.dart';
import '../../domain/usecases/add_weight_entry.dart';
import '../../domain/usecases/get_weight_data.dart';
import '../../domain/usecases/get_weekly_weight_data.dart';
import '../../domain/usecases/set_weight_goal.dart';

final weightRepositoryProvider = Provider<WeightRepositoryImpl>(
  (ref) => WeightRepositoryImpl(WeightDataSource()),
);

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

final currentWeightDataProvider = FutureProvider.family<WeightData?, String>(
  (ref, userId) async {
    print('currentWeightDataProvider: Fetching for userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    return await ref.read(getWeightDataProvider).call(userId);
  },
);

final currentWeightProvider = StateNotifierProvider.autoDispose
    .family<CurrentWeightNotifier, AsyncValue<double>, String>(
  (ref, userId) {
    print('currentWeightProvider: Initializing with userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    return CurrentWeightNotifier(
      ref,
      ref.read(getWeightDataProvider),
      ref.read(addWeightEntryProvider),
      userId,
    );
  },
);

final weightGoalProvider = StateNotifierProvider.autoDispose
    .family<WeightGoalNotifier, AsyncValue<WeightData>, String>(
  (ref, userId) {
    print('weightGoalProvider: Initializing with userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    return WeightGoalNotifier(
      ref,
      ref.read(weightRepositoryProvider),
      ref.read(setWeightGoalProvider),
      userId,
    );
  },
);

final weightProgressProvider = Provider.autoDispose.family<Map<String, dynamic>, String>(
  (ref, userId) {
    print('weightProgressProvider: Computing for userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    final currentWeight = ref.watch(currentWeightProvider(userId).select((value) => value.value ?? 75.0));
    final goal = ref.watch(weightGoalProvider(userId).select((value) => value.value));
    final goalWeight = goal?.goalWeight ?? 70.0;
    final initialWeight = goal?.initialWeight ?? 75.0;
    final progress = initialWeight != goalWeight
        ? ((initialWeight - currentWeight) / (initialWeight - goalWeight)).clamp(0.0, 1.0)
        : 0.0;
    print('weightProgressProvider: userId=$userId, currentWeight=$currentWeight, goalWeight=$goalWeight, initialWeight=$initialWeight, progress=$progress');
    Color color;
    if (progress >= 1.0) {
      color = const Color(0xFF4CAF50); // Green
    } else if (progress > 0.5) {
      color = const Color(0xFFFFEB3B); // Yellow
    } else if (progress >= 0.25) {
      color = const Color(0xFFFF9800); // Orange
    } else {
      color = const Color(0xFFF44336); // Red
    }
    return {'progress': progress, 'color': color};
  },
);

final weeklyWeightDataProvider = FutureProvider.family<List<WeightData>, String>(
  (ref, userId) async {
    print('weeklyWeightDataProvider: Fetching for userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    final asyncResult = await ref.read(getWeeklyWeightDataProvider).call(userId);
    final weeklyData = asyncResult.when(
      data: (data) {
        print('weeklyWeightDataProvider: Retrieved ${data.length} entries for userId=$userId');
        return data;
      },
      error: (e, _) {
        print('weeklyWeightDataProvider: Error for userId=$userId: $e');
        throw e;
      },
      loading: () {
        print('weeklyWeightDataProvider: Loading for userId=$userId');
        return [];
      },
    );
    final today = DateTime.now().toIso8601String().split('T')[0];
    final currentWeight = ref.watch(currentWeightProvider(userId).select((value) => value.value ?? 75.0));
    final goal = ref.watch(weightGoalProvider(userId).select((value) => value.value));
    print('weeklyWeightDataProvider: userId=$userId, today=$today, currentWeight=$currentWeight');
    final updatedData = weeklyData.where((data) => data.date != today).toList()
      ..add(WeightData(
        date: today,
        currentWeight: currentWeight,
        goalWeight: goal?.goalWeight ?? 70.0,
        initialWeight: goal?.initialWeight ?? 75.0,
        targetDate: goal?.targetDate,
      ));
    updatedData.sort((a, b) => a.date.compareTo(b.date));
    print('weeklyWeightDataProvider: Returning ${updatedData.length} entries for userId=$userId');
    return updatedData.cast<WeightData>();
  },
);

class CurrentWeightNotifier extends StateNotifier<AsyncValue<double>> {
  final Ref _ref;
  final GetWeightData _getWeightData;
  final AddWeightEntry _addWeightEntry;
  final String _userId;

  CurrentWeightNotifier(this._ref, this._getWeightData, this._addWeightEntry, this._userId)
      : super(const AsyncValue.loading()) {
    print('CurrentWeightNotifier: Initialized with userId=$_userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    _fetchWeight();
  }

  Future<void> _fetchWeight() async {
    print('CurrentWeightNotifier: Fetching weight for userId=$_userId');
    try {
      state = const AsyncValue.loading();
      final weightData = await _getWeightData.call(_userId);
      final weight = weightData?.currentWeight ?? 75.0;
      print('CurrentWeightNotifier: Fetched currentWeight=$weight for userId=$_userId');
      state = AsyncValue.data(weight);
    } catch (e, stackTrace) {
      print('CurrentWeightNotifier: Error fetching weight for userId=$_userId: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addWeight(double currentWeight) async {
    print('CurrentWeightNotifier: Adding currentWeight=$currentWeight for userId=$_userId');
    try {
      state = const AsyncValue.loading();
      final goal = await _ref.read(weightRepositoryProvider).getUserWeightGoal(_userId);
      final today = DateTime.now().toIso8601String().split('T')[0];
      await _addWeightEntry.call(
        _userId,
        today,
        currentWeight,
        goal?.goalWeight ?? 70.0,
        goal?.initialWeight ?? 75.0,
        goal?.targetDate,
      );
      print('CurrentWeightNotifier: Successfully added currentWeight=$currentWeight for userId=$_userId');
      state = AsyncValue.data(currentWeight);
    } catch (e, stackTrace) {
      print('CurrentWeightNotifier: Error adding weight for userId=$_userId: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class WeightGoalNotifier extends StateNotifier<AsyncValue<WeightData>> {
  final Ref _ref;
  final WeightRepositoryImpl _repository;
  final SetWeightGoal _setWeightGoal;
  final String _userId;

  WeightGoalNotifier(this._ref, this._repository, this._setWeightGoal, this._userId)
      : super(const AsyncValue.loading()) {
    print('WeightGoalNotifier: Initialized with userId=$_userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    _fetchGoal();
  }

  Future<void> _fetchGoal() async {
    print('WeightGoalNotifier: Fetching goal for userId=$_userId');
    try {
      state = const AsyncValue.loading();
      final goal = await _repository.getUserWeightGoal(_userId);
      final goalData = goal ?? WeightData(date: DateTime.now().toIso8601String().split('T')[0], currentWeight: 75.0, goalWeight: 70.0, initialWeight: 75.0);
      print('WeightGoalNotifier: Fetched goal=$goalData for userId=$_userId');
      state = AsyncValue.data(goalData);
    } catch (e, stackTrace) {
      print('WeightGoalNotifier: Error fetching goal for userId=$_userId: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setGoal(double goalWeight, double initialWeight, DateTime? targetDate) async {
    print('WeightGoalNotifier: Setting goal for userId=$_userId, goalWeight=$goalWeight, initialWeight=$initialWeight, targetDate=$targetDate');
    try {
      await _setWeightGoal.call(_userId, goalWeight, initialWeight, targetDate);
      print('WeightGoalNotifier: Successfully set goal for userId=$_userId');
      await _fetchGoal();
    } catch (e, stackTrace) {
      print('WeightGoalNotifier: Error setting goal for userId=$_userId: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }
} 