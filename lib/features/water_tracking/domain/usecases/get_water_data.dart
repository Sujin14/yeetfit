import '../../data/model/water_model.dart';
import '../repositories/water_repository.dart';

// Use case for fetching water data.
class GetWaterData {
  final WaterRepository _repository;

  const GetWaterData(this._repository);

  Future<WaterData?> call(String userId) async {
    return await _repository.getWaterData(userId);
  }
}