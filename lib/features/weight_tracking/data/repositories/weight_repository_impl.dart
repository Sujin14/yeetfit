import '../datasources/weight_datasource.dart';
import '../model/weight_model.dart';
import '../../domain/repositories/weight_repository.dart';

// Implementation of [WeightRepository] using Firestore data source.
class WeightRepositoryImpl implements WeightRepository {
  final WeightDataSource _dataSource;

  const WeightRepositoryImpl(this._dataSource);

  @override
  Future<void> updateWeight(
    String userId,
    double currentWeight,
    double? goalWeight,
    double? initialWeight,
    DateTime? targetDate,
  ) async {
    await _dataSource.updateWeight(userId, currentWeight, goalWeight, initialWeight, targetDate);
  }

  @override
  Future<WeightData?> getWeightData(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return await _dataSource.getWeightData(userId, today);
  }

  @override
  Future<WeightData?> getUserWeightGoal(String userId) async {
    return await _dataSource.getUserWeightGoal(userId);
  }

  @override
  Future<void> addWeightEntry(
    String userId,
    String date,
    double currentWeight,
    double goalWeight,
    double initialWeight,
    DateTime? targetDate,
  ) async {
    await _dataSource.addWeightEntry(userId, date, currentWeight, goalWeight, initialWeight, targetDate);
  }

  @override
  Future<void> setUserWeightGoal(String userId, double goalWeight, double initialWeight, DateTime? targetDate) async {
    await _dataSource.setUserWeightGoal(userId, goalWeight, initialWeight, targetDate);
  }

  @override
  Future<List<WeightData>> getWeeklyWeightData(String userId) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 6));
    return await _dataSource.getWeeklyWeightData(userId, startDate, endDate);
  }

  @override
  Future<void> updateCurrentWeight(String userId, double currentWeight) async {
    await updateWeight(userId, currentWeight, null, null, null);
  }
}