import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/model/water_model.dart';

abstract class WaterRepository {
  Future<WaterData?> getWaterData(String userId);
  Future<int> getWaterGoal(String userId);
  Future<void> addGlass(String userId);
  Future<void> removeGlass(String userId);
  Future<void> setWaterGoal(String userId, int newGoal);
  Future<AsyncValue<List<WaterData>>> getWeeklyWaterData(String userId);
}