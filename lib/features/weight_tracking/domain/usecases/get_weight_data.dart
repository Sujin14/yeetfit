import '../../data/model/weight_model.dart';
import '../repositories/weight_repository.dart';

class GetWeightData {
  final WeightRepository _repository;

  GetWeightData(this._repository);

  Future<WeightData?> call(String userId) async {
    return await _repository.getWeightData(userId);
  }
}