import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/sleep_model.dart';

abstract class SleepRepository {
  Future<SleepData?> getSleepData(String userId);
  Future<double> getSleepGoal(String userId);
  Future<void> addSleepEntry(
    String userId,
    DateTime bedtime,
    DateTime wakeUpTime,
    double duration,
  );
  Future<void> setSleepGoal(String userId, double newGoal);
  Future<AsyncValue<List<SleepData>>> getWeeklySleepData(String userId);
}
