import '../datasource/sleep_data_source.dart';
import '../model/sleep_model.dart';
import '../../domain/repositories/sleep_repository.dart';

// Implementation of [SleepRepository] using Firestore.
class SleepRepositoryImpl implements SleepRepository {
  final SleepDataSource _dataSource;

  const SleepRepositoryImpl(this._dataSource);

  @override
  Future<SleepData?> getSleepData(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return await _dataSource.getSleepData(userId, today);
  }

  @override
  Future<double> getSleepGoal(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return await _dataSource.getSleepGoal(userId, today);
  }

  @override
  Future<void> addSleepEntry(String userId, DateTime bedtime, DateTime wakeUpTime, double duration) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final currentData = await _dataSource.getSleepData(userId, today);
    final goalHours = currentData?.goalHours ?? 8.0;
    await _dataSource.addSleepEntry(userId, today, bedtime, wakeUpTime, duration, goalHours);
  }

  @override
  Future<void> setSleepGoal(String userId, double newGoal) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final currentData = await _dataSource.getSleepData(userId, today);
    final duration = currentData?.duration ?? 0.0;
    final bedtime = currentData?.bedtime ?? DateTime.now();
    final wakeUpTime = currentData?.wakeUpTime ?? DateTime.now();
    await _dataSource.addSleepEntry(userId, today, bedtime, wakeUpTime, duration, newGoal);
  }

  @override
  Future<List<SleepData>> getWeeklySleepData(String userId) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 6));
    return await _dataSource.getWeeklySleepData(userId, startDate, endDate);
  }
}