import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/food_datasource.dart';
import '../../data/model/food_model.dart';
import '../../data/repositories/food_repository.dart';
import '../../domain/usecases/food_usecases.dart';

/// Repository provider
final foodRepositoryProvider = Provider<FoodRepositoryImpl>(
  (ref) => FoodRepositoryImpl(FoodDataSource()),
);

/// UseCase providers
final addFoodEntryProvider = Provider<AddFoodEntry>(
  (ref) => AddFoodEntry(ref.read(foodRepositoryProvider)),
);

final setCalorieGoalProvider = Provider<SetCalorieGoal>(
  (ref) => SetCalorieGoal(ref.read(foodRepositoryProvider)),
);

final getFoodDataProvider = Provider<GetFoodData>(
  (ref) => GetFoodData(ref.read(foodRepositoryProvider)),
);

final getWeeklyFoodDataProvider = Provider<GetWeeklyFoodData>(
  (ref) => GetWeeklyFoodData(ref.read(foodRepositoryProvider)),
);

/// Provider for daily calories
final dailyCaloriesProvider = StateNotifierProvider.autoDispose
    .family<DailyCaloriesNotifier, AsyncValue<double>, String>(
  (ref, userIdAndMealType) {
    final parts = userIdAndMealType.split('|');
    final userId = parts[0];
    final mealType = parts[1];
    return DailyCaloriesNotifier(
      ref,
      ref.read(getFoodDataProvider),
      ref.read(addFoodEntryProvider),
      userId,
      mealType,
    );
  },
);

/// Provider for calorie goal
final calorieGoalProvider = StateNotifierProvider.autoDispose
    .family<CalorieGoalNotifier, AsyncValue<double>, String>(
  (ref, userId) => CalorieGoalNotifier(
    ref,
    ref.read(foodRepositoryProvider),
    ref.read(setCalorieGoalProvider),
    userId,
  ),
);

/// Provider for daily progress color
final dailyCalorieProgressColorProvider = Provider.autoDispose.family<Color, String>(
  (ref, userIdAndDate) {
    final parts = userIdAndDate.split('|');
    final userId = parts[0];
    final date = parts[1];
    final mealTypes = ['Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner'];
    double totalCalories = 0.0;
    
    for (final mealType in mealTypes) {
      final calories = ref.watch(dailyCaloriesProvider('$userId|$mealType').select((value) => value.value ?? 0.0));
      totalCalories += calories;
    }
    
    final goalCalories = ref.watch(calorieGoalProvider(userId).select((value) => value.value ?? 1750.0));
    final progress = goalCalories > 0 ? totalCalories / goalCalories : 0.0;

    if (progress >= 1.0) return const Color(0xFF4CAF50); // Green for 100%
    if (progress > 0.75) return const Color(0xFFFFEB3B); // Yellow for >75%
    if (progress >= 0.5) return const Color(0xFFFF9800); // Orange for ~50%
    return const Color(0xFFF44336); // Red for <50%
  },
);

/// Weekly Food Data Provider
final weeklyFoodDataProvider = FutureProvider.family<Map<String, List<FoodItem>>, String>(
  (ref, userId) async {
    final mealTypes = ['Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner'];
    final Map<String, List<FoodItem>> weeklyData = {};
    
    for (final mealType in mealTypes) {
      final asyncResult = await ref.read(getWeeklyFoodDataProvider).call(userId, mealType);
      weeklyData[mealType] = asyncResult.when(
        data: (data) => data,
        error: (e, _) => throw e,
        loading: () => [],
      );
    }
    
    return weeklyData;
  },
);

/// Notifier for daily calories
class DailyCaloriesNotifier extends StateNotifier<AsyncValue<double>> {
  final Ref _ref;
  final GetFoodData _getFoodData;
  final AddFoodEntry _addFoodEntry;
  final String _userId;
  final String _mealType;

  DailyCaloriesNotifier(this._ref, this._getFoodData, this._addFoodEntry, this._userId, this._mealType)
      : super(const AsyncValue.loading()) {
    _fetchCalories();
  }

  Future<void> _fetchCalories() async {
    try {
      state = const AsyncValue.loading();
      final foodData = await _getFoodData.call(_userId, _mealType);
      state = AsyncValue.data(foodData?.calories ?? 0.0);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateCalories(
    String foodName,
    double calories,
    double protein,
    double fat,
    double carbs,
    double fiber,
  ) async {
    try {
      state = const AsyncValue.loading();
      await _addFoodEntry.call(_userId, _mealType, foodName, calories, protein, fat, carbs, fiber);
      state = AsyncValue.data(calories);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Notifier for calorie goal
class CalorieGoalNotifier extends StateNotifier<AsyncValue<double>> {
  final Ref _ref;
  final FoodRepositoryImpl _repository;
  final SetCalorieGoal _setCalorieGoal;
  final String _userId;

  CalorieGoalNotifier(this._ref, this._repository, this._setCalorieGoal, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchGoal();
  }

  Future<void> _fetchGoal() async {
    try {
      state = const AsyncValue.loading();
      final goal = await _repository.getCalorieGoal(_userId);
      state = AsyncValue.data(goal);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setGoal(double newGoal) async {
    try {
      await _setCalorieGoal.call(_userId, newGoal);
      await _fetchGoal();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}