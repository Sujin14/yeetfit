import '../datasources/weight_datasource.dart';
import '../../domain/entities/weight_data.dart';
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
  ) => _dataSource.updateWeight(
    userId,
    currentWeight,
    goalWeight,
    initialWeight,
    targetDate,
  );

  @override
  Future<WeightData?> getWeightData(String userId) => _dataSource.getWeightData(
    userId,
    DateTime.now().toIso8601String().split('T')[0],
  );

  @override
  Future<WeightData?> getUserWeightGoal(String userId) =>
      _dataSource.getUserWeightGoal(userId);

  @override
  Future<void> setUserWeightGoal(
    String userId,
    double goalWeight,
    double initialWeight,
    DateTime? targetDate,
  ) => _dataSource.setUserWeightGoal(
    userId,
    goalWeight,
    initialWeight,
    targetDate,
  );

  @override
  Future<List<WeightData>> getWeeklyWeightData(String userId) async {
    final endDate = DateTime.now();
    // Midnight six days ago: entries are timestamped at 00:00, and the chart
    // needs today plus the six days before it.
    final startDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    ).subtract(const Duration(days: 6));
    return List<WeightData>.of(
      await _dataSource.getWeeklyWeightData(userId, startDate, endDate),
    );
  }

  @override
  Future<void> updateCurrentWeight(String userId, double currentWeight) =>
      updateWeight(userId, currentWeight, null, null, null);
}
