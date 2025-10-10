import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../datasources/steps_datasource.dart';
import '../model/steps_model.dart';
import '../../domain/repositories/steps_repository.dart';

class StepsRepositoryImpl implements StepsRepository {
  final StepsDataSource _dataSource;

  StepsRepositoryImpl(this._dataSource);

  @override
  Future<StepsData?> getStepsData(String userId, String date) async {
    return await _dataSource.getStepsData(userId, date);
  }

  @override
  Future<int> getStepsGoal(String userId, String date) async {
    return await _dataSource.getStepsGoal(userId, date);
  }

  @override
  Future<void> addStepsEntry(String userId, int steps) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final currentData = await _dataSource.getStepsData(userId, today);
    final goalSteps = currentData?.goalSteps ?? 10000;
    final caloriesBurned = steps * 0.04;
    await _dataSource.addStepsEntry(
      userId,
      today,
      steps,
      goalSteps,
      caloriesBurned,
    );
  }

  @override
  Future<void> setStepsGoal(String userId, int newGoal) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final currentData = await _dataSource.getStepsData(userId, today);
    final steps = currentData?.steps ?? 0;
    final caloriesBurned = steps * 0.04;
    await _dataSource.addStepsEntry(
      userId,
      today,
      steps,
      newGoal,
      caloriesBurned,
    );
  }

  @override
  Future<AsyncValue<List<StepsData>>> getWeeklyStepsData(String userId) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 6));
      final data = await _dataSource.getWeeklyStepsData(
        userId,
        startDate,
        endDate,
      );
      return AsyncValue.data(data);
    } catch (e, stackTrace) {
      return AsyncValue.error(e, stackTrace);
    }
  }

  @override
  Future<void> syncLocalData(String userId) async {
    await _dataSource.syncLocalData(userId);
  }

  @override
  Future<void> updateDailySteps(String userId, String date, int steps) async {
    final goalSteps = await getStepsGoal(userId, date);
    final caloriesBurned = steps * 0.04;
    await _dataSource.addStepsEntry(userId, date, steps, goalSteps, caloriesBurned);
  }
}