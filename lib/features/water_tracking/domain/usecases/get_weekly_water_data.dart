import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/water_model.dart';
import '../repositories/water_repository.dart';

class GetWeeklyWaterData {
  final WaterRepository _repository;

  GetWeeklyWaterData(this._repository);

  Future<AsyncValue<List<WaterData>>> call(String userId) async {
    return await _repository.getWeeklyWaterData(userId);
  }
}