import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/food_datasource.dart';
import '../../data/model/food_model.dart';
import '../../data/repositories/food_repository.dart';
import '../../domain/usecases/food_usecases.dart';

final foodRepositoryProvider = Provider<FoodRepositoryImpl>(
  (ref) => FoodRepositoryImpl(FoodDataSource()),
);

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

final dailyFoodItemsProvider = StateNotifierProvider.autoDispose
    .family<DailyFoodItemsNotifier, AsyncValue<List<FoodItem>>, String>(
  (ref, userIdAndMealType) {
    final parts = userIdAndMealType.split('|');
    final userId = parts[0];
    final mealType = parts[1];
    return DailyFoodItemsNotifier(
      ref,
      ref.read(getFoodDataProvider),
      ref.read(addFoodEntryProvider),
      userId,
      mealType,
    );
  },
);

final dailyCaloriesProvider = Provider.autoDispose.family<double, String>(
  (ref, userIdAndMealType) {
    final foodItems = ref.watch(dailyFoodItemsProvider(userIdAndMealType)).value ?? [];
    return foodItems.fold(0.0, (sum, item) => sum + item.calories);
  },
);

final dailyNutrientsProvider = Provider.autoDispose.family<Map<String, double>, String>(
  (ref, userId) {
    final mealTypes = ['Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner'];
    final nutrients = {'protein': 0.0, 'fat': 0.0, 'carbs': 0.0, 'fiber': 0.0};
    for (final mealType in mealTypes) {
      final foodItems = ref.watch(dailyFoodItemsProvider('$userId|$mealType')).value ?? [];
      for (final item in foodItems) {
        nutrients['protein'] = nutrients['protein']! + item.protein;
        nutrients['fat'] = nutrients['fat']! + item.fat;
        nutrients['carbs'] = nutrients['carbs']! + item.carbs;
        nutrients['fiber'] = nutrients['fiber']! + item.fiber;
      }
    }
    return nutrients;
  },
);

final calorieGoalProvider = StateNotifierProvider.autoDispose
    .family<CalorieGoalNotifier, AsyncValue<double>, String>(
  (ref, userId) => CalorieGoalNotifier(
    ref,
    ref.read(foodRepositoryProvider),
    ref.read(setCalorieGoalProvider),
    userId,
  ),
);

final dailyCalorieProgressColorProvider = Provider.autoDispose.family<Color, String>(
  (ref, userIdAndDate) {
    final parts = userIdAndDate.split('|');
    final userId = parts[0];
    final mealTypes = ['Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner'];
    double totalCalories = 0.0;

    for (final mealType in mealTypes) {
      final calories = ref.watch(dailyCaloriesProvider('$userId|$mealType'));
      totalCalories += calories;
    }

    final goalCalories = ref.watch(calorieGoalProvider(userId)).value ?? 1750.0;
    final progress = goalCalories > 0 ? totalCalories / goalCalories : 0.0;

    if (progress >= 1.0) return const Color(0xFF4CAF50);
    if (progress > 0.75) return const Color(0xFFFFEB3B);
    if (progress >= 0.5) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  },
);

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

class DailyFoodItemsNotifier extends StateNotifier<AsyncValue<List<FoodItem>>> {
  final Ref _ref;
  final GetFoodData _getFoodData;
  final AddFoodEntry _addFoodEntry;
  final String _userId;
  final String _mealType;

  DailyFoodItemsNotifier(this._ref, this._getFoodData, this._addFoodEntry, this._userId, this._mealType)
      : super(const AsyncValue.loading()) {
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    try {
      state = const AsyncValue.loading();
      final foodData = await _getFoodData.call(_userId, _mealType);
      state = AsyncValue.data(foodData);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addFoodItem(
    String foodName,
    double calories,
    double protein,
    double fat,
    double carbs,
    double fiber,
    double quantity,
    String? image,
  ) async {
    try {
      state = const AsyncValue.loading();
      await _addFoodEntry.call(_userId, _mealType, foodName, calories, protein, fat, carbs, fiber, quantity, image);
      await _fetchFoodItems();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

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