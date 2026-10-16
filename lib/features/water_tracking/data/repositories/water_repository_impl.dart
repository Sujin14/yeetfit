import 'dart:math';
import '../datasources/water_datasource.dart';
import '../../domain/entities/water_data.dart';
import '../../domain/repositories/water_repository.dart';

String _todayKey() => DateTime.now().toIso8601String().split('T')[0];

// Implementation of [WaterRepository] using Firestore.
class WaterRepositoryImpl implements WaterRepository {
  final WaterDataSource _dataSource;

  const WaterRepositoryImpl(this._dataSource);

  @override
  Future<WaterData?> getWaterData(String userId) =>
      _dataSource.getWaterData(userId, _todayKey());

  @override
  Future<void> addGlass(String userId) async {
    final today = _todayKey();
    final currentData = await _dataSource.getWaterData(userId, today);
    await _dataSource.updateWaterData(
      userId,
      today,
      (currentData?.glassesConsumed ?? 0) + 1,
      currentData?.goalGlasses ?? 8,
    );
  }

  @override
  Future<void> removeGlass(String userId) async {
    final today = _todayKey();
    final currentData = await _dataSource.getWaterData(userId, today);
    await _dataSource.updateWaterData(
      userId,
      today,
      max(0, (currentData?.glassesConsumed ?? 0) - 1),
      currentData?.goalGlasses ?? 8,
    );
  }

  @override
  Future<void> setWaterGoal(String userId, int newGoal) async {
    final today = _todayKey();
    final currentData = await _dataSource.getWaterData(userId, today);
    await _dataSource.updateWaterData(
      userId,
      today,
      currentData?.glassesConsumed ?? 0,
      newGoal,
    );
  }

  @override
  Future<List<WaterData>> getWeeklyWaterData(String userId) async {
    final endDate = DateTime.now();
    // From midnight six days ago, so the oldest day isn't cut off at the
    // current time of day.
    final startDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    ).subtract(const Duration(days: 6));
    return List<WaterData>.of(
      await _dataSource.getWeeklyWaterData(userId, startDate, endDate),
    );
  }
}
