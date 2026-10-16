import '../datasources/health_steps_datasource.dart';
import '../datasources/steps_datasource.dart';
import '../../domain/entities/steps_data.dart';
import '../../domain/repositories/steps_repository.dart';

// Implementation of [StepsRepository] with offline support.
class StepsRepositoryImpl implements StepsRepository {
  final StepsDataSource _dataSource;
  final HealthStepsDataSource _healthDataSource;

  StepsRepositoryImpl(
    this._dataSource, {
    HealthStepsDataSource? healthDataSource,
  }) : _healthDataSource = healthDataSource ?? HealthStepsDataSource();

  @override
  Future<void> requestHealthAccessOnce() =>
      _healthDataSource.requestAccessOnce();

  @override
  Future<void> requestHealthAccess() => _healthDataSource.requestAccess();

  @override
  Future<int?> getHealthSteps(DateTime start, DateTime end) =>
      _healthDataSource.getSteps(start, end);

  @override
  Future<int> getStepsGoal(String userId, String date) =>
      _dataSource.getStepsGoal(userId, date);

  @override
  Future<void> setStepsGoal(String userId, int newGoal) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final steps = (await _dataSource.getStepsData(userId, today))?.steps ?? 0;
    await _dataSource.addStepsEntry(
      userId,
      today,
      steps,
      newGoal,
      StepsData.caloriesFor(steps),
    );
  }

  @override
  Future<List<StepsData>> getWeeklyStepsData(String userId) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 6));
    // A List<StepsModel> rejects plain StepsData at runtime (e.g. in
    // firstWhere's orElse), so hand callers a genuine List<StepsData>.
    return List<StepsData>.of(
      await _dataSource.getWeeklyStepsData(userId, startDate, endDate),
    );
  }

  @override
  Future<void> syncLocalData(String userId) =>
      _dataSource.syncLocalData(userId);

  @override
  Future<void> updateDailySteps(String userId, String date, int steps) async {
    final goalSteps = await getStepsGoal(userId, date);
    await _dataSource.addStepsEntry(
      userId,
      date,
      steps,
      goalSteps,
      StepsData.caloriesFor(steps),
    );
  }
}
