import '../../data/model/water_model.dart';
import '../repositories/water_repository.dart';

class GetWaterData {
  final WaterRepository _repository;

  GetWaterData(this._repository);

  Future<WaterData?> call(String userId) async {
    return await _repository.getWaterData(userId);
  }
}