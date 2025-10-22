import '../../data/model/weight_model.dart';
import '../repositories/weight_repository.dart';

// Use case for fetching weekly weight data.
class GetWeeklyWeightData {
  final WeightRepository _repository;

  const GetWeeklyWeightData(this._repository);

  Future<List<WeightData>> call(String userId) async {
    return await _repository.getWeeklyWeightData(userId);
  }
}