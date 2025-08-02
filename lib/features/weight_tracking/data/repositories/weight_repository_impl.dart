import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../datasources/weight_datasource.dart';
import '../model/weight_model.dart';
import '../../domain/repositories/weight_repository.dart';

class WeightRepositoryImpl implements WeightRepository {
  final WeightDataSource _dataSource;

  WeightRepositoryImpl(this._dataSource);

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
  Future<AsyncValue<List<WeightData>>> getWeeklyWeightData(String userId) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 6));
      final data = await _dataSource.getWeeklyWeightData(userId, startDate, endDate);
      return AsyncValue.data(data);
    } catch (e, stackTrace) {
      return AsyncValue.error(e, stackTrace);
    }
  }
}