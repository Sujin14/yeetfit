import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/food_datasource.dart';
import '../../data/model/food_model.dart';

abstract class FoodRepository {
  Future<List<FoodItem>> getFoodData(String userId, String mealType);
  Future<double> getCalorieGoal(String userId);
  Future<void> addFoodEntry(
    String userId,
    String mealType,
    String foodName,
    double calories,
    double protein,
    double fat,
    double carbs,
    double fiber,
    double quantity,
    String? image,
  );
  Future<void> setCalorieGoal(String userId, double newGoal);
  Future<AsyncValue<List<FoodItem>>> getWeeklyFoodData(String userId, String mealType);
}

class FoodRepositoryImpl implements FoodRepository {
  final FoodDataSource _dataSource;

  FoodRepositoryImpl(this._dataSource);

  @override
  Future<List<FoodItem>> getFoodData(String userId, String mealType) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return await _dataSource.getFoodData(userId, today, mealType);
  }

  @override
  Future<double> getCalorieGoal(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return await _dataSource.getCalorieGoal(userId, today);
  }

  @override
  Future<void> addFoodEntry(
    String userId,
    String mealType,
    String foodName,
    double calories,
    double protein,
    double fat,
    double carbs,
    double fiber,
    double quantity,
    String? image,
  ) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    await _dataSource.addFoodEntry(
      userId,
      today,
      mealType,
      foodName,
      calories,
      protein,
      fat,
      carbs,
      fiber,
      quantity,
      image,
    );
  }

  @override
  Future<void> setCalorieGoal(String userId, double newGoal) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    await _dataSource.setCalorieGoal(userId, today, newGoal);
  }

  @override
  Future<AsyncValue<List<FoodItem>>> getWeeklyFoodData(String userId, String mealType) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 6));
      final data = await _dataSource.getWeeklyFoodData(userId, startDate, endDate, mealType);
      return AsyncValue.data(data);
    } catch (e, stackTrace) {
      return AsyncValue.error(e, stackTrace);
    }
  }
}