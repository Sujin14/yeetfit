import '../../data/model/weight_model.dart';
import '../repositories/weight_repository.dart';

// Use case for fetching weight data.
class GetWeightData {
  final WeightRepository _repository;

  const GetWeightData(this._repository);

  Future<WeightData?> call(String userId) async {
    return await _repository.getWeightData(userId);
  }
}