import '../datasource/sleep_data_source.dart';
import '../../domain/entities/sleep_data.dart';
import '../../domain/repositories/sleep_repository.dart';

String _todayKey() => DateTime.now().toIso8601String().split('T')[0];

// Implementation of [SleepRepository] using Firestore.
class SleepRepositoryImpl implements SleepRepository {
  final SleepDataSource _dataSource;

  const SleepRepositoryImpl(this._dataSource);

  @override
  Stream<SleepData?> watchTodaySleep(String userId) =>
      _dataSource.watchSleepData(userId, _todayKey());

  @override
  Future<void> addSleepEntry(
    String userId,
    DateTime bedtime,
    DateTime wakeUpTime,
    double duration,
  ) async {
    final today = _todayKey();
    final currentData = await _dataSource.getSleepData(userId, today);
    await _dataSource.addSleepEntry(
      userId,
      today,
      bedtime,
      wakeUpTime,
      duration,
      currentData?.goalHours ?? 8.0,
    );
  }

  @override
  Future<void> setSleepGoal(String userId, double newGoal) =>
      _dataSource.setSleepGoal(userId, _todayKey(), newGoal);

  @override
  Future<List<SleepData>> getWeeklySleepData(String userId) async {
    final endDate = DateTime.now();
    // Midnight six days ago: entries are timestamped at 00:00, and the chart
    // needs today plus the six days before it.
    final startDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    ).subtract(const Duration(days: 6));
    return List<SleepData>.of(
      await _dataSource.getWeeklySleepData(userId, startDate, endDate),
    );
  }
}
