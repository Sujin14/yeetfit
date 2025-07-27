import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/weight_model.dart';

abstract class WeightRepository {
  Future<WeightData?> getWeightData(String userId);
  Future<WeightData?> getUserWeightGoal(String userId);
  Future<void> addWeightEntry(
      String userId, String date, double currentWeight, double goalWeight, double initialWeight, DateTime? targetDate);
  Future<void> setUserWeightGoal(String userId, double goalWeight, double initialWeight, DateTime? targetDate);
  Future<AsyncValue<List<WeightData>>> getWeeklyWeightData(String userId);
}