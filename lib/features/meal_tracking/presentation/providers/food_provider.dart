import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/data/models/user_info_model.dart';
import '../../data/datasources/food_datasource.dart';
import '../../data/model/food_model.dart';
import '../../domain/repositories/food_repository.dart';
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

final userInfoProvider = FutureProvider.family<UserInfoModel, String>((ref, userId) async {
  if (userId.isEmpty) {
    throw Exception('User not logged in');
  }
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (!doc.exists) {
    throw Exception('User data not found');
  }
  return UserInfoModel.fromMap(doc.data()!);
});

final dailyFoodItemsProvider = StateNotifierProvider.autoDispose.family<DailyFoodItemsNotifier, AsyncValue<List<FoodItem>>, String>(
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

final calorieGoalProvider = StateNotifierProvider.autoDispose.family<CalorieGoalNotifier, AsyncValue<double>, String>(
  (ref, userId) => CalorieGoalNotifier(
    ref,
    ref.read(foodRepositoryProvider),
    ref.read(setCalorieGoalProvider),
    userId,
  ),
);

final nutrientGoalsProvider = Provider.family<Map<String, double>, String>((ref, userId) {
  final userInfoAsync = ref.watch(userInfoProvider(userId));
  return userInfoAsync.when(
    data: (userInfo) {
      double bmr;
      if (userInfo.gender.toLowerCase() == 'male') {
        bmr = 10 * userInfo.currentWeight + 6.25 * userInfo.height - 5 * userInfo.age + 5;
      } else {
        bmr = 10 * userInfo.currentWeight + 6.25 * userInfo.height - 5 * userInfo.age - 161;
      }
      double activityFactor = userInfo.activityLevel == 'Moderately Active' ? 1.55 : 1.2;
      double totalCalories = bmr * activityFactor;
      if (userInfo.goal.toLowerCase() == 'weight loss') {
        totalCalories -= 500;
      }
      final proteinCalories = totalCalories * 0.20;
      final fatCalories = totalCalories * 0.30;
      final carbCalories = totalCalories * 0.45;
      final fiberGrams = totalCalories < 2000 ? 25.0 : 30.0;
      return {
        'protein': proteinCalories / 4,
        'fat': fatCalories / 9,
        'carbs': carbCalories / 4,
        'fiber': fiberGrams,
      };
    },
    loading: () => {'protein': 70.0, 'fat': 50.0, 'carbs': 250.0, 'fiber': 30.0},
    error: (_, __) => {'protein': 70.0, 'fat': 50.0, 'carbs': 250.0, 'fiber': 30.0},
  );
});

final mealCalorieGoalsProvider = Provider.family<Map<String, double>, String>((ref, userId) {
  final userInfoAsync = ref.watch(userInfoProvider(userId));
  return userInfoAsync.when(
    data: (userInfo) {
      double bmr;
      if (userInfo.gender.toLowerCase() == 'male') {
        bmr = 10 * userInfo.currentWeight + 6.25 * userInfo.height - 5 * userInfo.age + 5;
      } else {
        bmr = 10 * userInfo.currentWeight + 6.25 * userInfo.height - 5 * userInfo.age - 161;
      }
      double activityFactor = userInfo.activityLevel == 'Moderately Active' ? 1.55 : 1.2;
      double totalCalories = bmr * activityFactor;
      if (userInfo.goal.toLowerCase() == 'weight loss') {
        totalCalories -= 500;
      }
      return {
        'Breakfast': totalCalories * 0.25,
        'Lunch': totalCalories * 0.25,
        'Dinner': totalCalories * 0.25,
        'Morning Snack': totalCalories * 0.125,
        'Evening Snack': totalCalories * 0.125,
      };
    },
    loading: () => {
      'Breakfast': 1750.0 / 5,
      'Lunch': 1750.0 / 5,
      'Dinner': 1750.0 / 5,
      'Morning Snack': 1750.0 / 10,
      'Evening Snack': 1750.0 / 10,
    },
    error: (_, __) => {
      'Breakfast': 1750.0 / 5,
      'Lunch': 1750.0 / 5,
      'Dinner': 1750.0 / 5,
      'Morning Snack': 1750.0 / 10,
      'Evening Snack': 1750.0 / 10,
    },
  );
});

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
    final goalAsync = ref.watch(calorieGoalProvider(userId));
    return goalAsync.when(
      data: (goalCalories) {
        final progress = goalCalories > 0 ? totalCalories / goalCalories : 0.0;
        if (progress >= 1.0) return AppTheme.colors['threeQuarterProgress']!;
        if (progress > 0.75) return AppTheme.colors['carbsProgress']!;
        if (progress >= 0.5) return AppTheme.colors['quarterProgress']!;
        return AppTheme.colors['error']!;
      },
      loading: () => AppTheme.colors['quarterProgress']!,
      error: (_, __) => AppTheme.colors['error']!,
    );
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

final calorieTrackingProvider = StateNotifierProvider<CalorieTrackingNotifier, AsyncValue<void>>(
  (ref) => CalorieTrackingNotifier(ref),
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
      final savedGoal = await _repository.getCalorieGoal(_userId);
      if (savedGoal > 0) {
        state = AsyncValue.data(savedGoal);
        return;
      }
      final userInfo = await _ref.read(userInfoProvider(_userId).future);
      double bmr;
      if (userInfo.gender.toLowerCase() == 'male') {
        bmr = 10 * userInfo.currentWeight + 6.25 * userInfo.height - 5 * userInfo.age + 5;
      } else {
        bmr = 10 * userInfo.currentWeight + 6.25 * userInfo.height - 5 * userInfo.age - 161;
      }
      double activityFactor = userInfo.activityLevel == 'Moderately Active' ? 1.55 : 1.2;
      double totalCalories = bmr * activityFactor;
      if (userInfo.goal.toLowerCase() == 'weight loss') {
        totalCalories -= 500;
      }
      await _setCalorieGoal.call(_userId, totalCalories);
      state = AsyncValue.data(totalCalories);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setGoal(double newGoal) async {
    try {
      await _setCalorieGoal.call(_userId, newGoal);
      state = AsyncValue.data(newGoal);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class CalorieTrackingNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  CalorieTrackingNotifier(this._ref) : super(const AsyncValue.data(null));

  void navigateBack(BuildContext context) {
    context.go('/user-dashboard');
  }
}