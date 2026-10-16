import '../../domain/entities/food_item.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/food_datasource.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodDataSource _dataSource;

  const FoodRepositoryImpl(this._dataSource);

  @override
  Stream<List<FoodItem>> watchTodayMeals(String userId, String date) =>
      _dataSource.watchTodayMeals(userId, date);

  @override
  Future<void> addFoodEntry(String userId, FoodItem item) =>
      _dataSource.addFoodEntry(userId, item);

  @override
  Future<void> deleteFoodEntry(String userId, String entryId) =>
      _dataSource.deleteFoodEntry(userId, entryId);

  @override
  Future<List<FoodItem>> getWeeklyFoodData(String userId) =>
      _dataSource.getWeeklyFoodData(userId);
}
