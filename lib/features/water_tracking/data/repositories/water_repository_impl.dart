import '../../domain/repositories/water_repository.dart';
import '../datasources/water_datasource.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/water_model.dart';

class WaterRepositoryImpl implements WaterRepository {
  final WaterDataSource _dataSource;

  WaterRepositoryImpl(this._dataSource);

  @override
  Future<WaterData?> getWaterData(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return await _dataSource.getWaterData(userId, today);
  }

  @override
  Future<int> getWaterGoal(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return await _dataSource.getWaterGoal(userId, today);
  }

  @override
  Future<void> addGlass(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final currentData = await _dataSource.getWaterData(userId, today);
    final glassesConsumed = (currentData?.glassesConsumed ?? 0) + 1;
    final goalGlasses = currentData?.goalGlasses ?? 8;
    await _dataSource.updateWaterData(
      userId,
      today,
      glassesConsumed,
      goalGlasses,
    );
  }

  @override
  Future<void> removeGlass(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final currentData = await _dataSource.getWaterData(userId, today);
    final glassesConsumed = (currentData?.glassesConsumed ?? 0) > 0
        ? (currentData!.glassesConsumed - 1)
        : 0;
    final goalGlasses = currentData?.goalGlasses ?? 8;
    await _dataSource.updateWaterData(
      userId,
      today,
      glassesConsumed,
      goalGlasses,
    );
  }

  @override
  Future<void> setWaterGoal(String userId, int newGoal) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final currentData = await _dataSource.getWaterData(userId, today);
    final glassesConsumed = currentData?.glassesConsumed ?? 0;
    await _dataSource.updateWaterData(userId, today, glassesConsumed, newGoal);
  }

  @override
  Future<AsyncValue<List<WaterData>>> getWeeklyWaterData(String userId) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 6));
      final data = await _dataSource.getWeeklyWaterData(
        userId,
        startDate,
        endDate,
      );
      return AsyncValue.data(data);
    } catch (e, stackTrace) {
      return AsyncValue.error(e, stackTrace);
    }
  }
}
