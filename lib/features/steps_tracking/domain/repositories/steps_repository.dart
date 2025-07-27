import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/steps_model.dart';

abstract class StepsRepository {
  Future<StepsData?> getStepsData(String userId);
  Future<int> getStepsGoal(String userId);
  Future<void> addStepsEntry(String userId, int steps);
  Future<void> setStepsGoal(String userId, int newGoal);
  Future<AsyncValue<List<StepsData>>> getWeeklyStepsData(String userId);
}
