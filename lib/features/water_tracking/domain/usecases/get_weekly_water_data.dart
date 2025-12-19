import '../../data/model/water_model.dart';
import '../repositories/water_repository.dart';

// Use case for fetching weekly water data.
class GetWeeklyWaterData {
  final WaterRepository _repository;

  const GetWeeklyWaterData(this._repository);

  Future<List<WaterData>> call(String userId) async {
    return await _repository.getWeeklyWaterData(userId);
  }
}