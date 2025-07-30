import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/weight_model.dart';
import '../repositories/weight_repository.dart';

class GetWeeklyWeightData {
  final WeightRepository _repository;

  GetWeeklyWeightData(this._repository);

  Future<AsyncValue<List<WeightData>>> call(String userId) async {
    return await _repository.getWeeklyWeightData(userId);
  }
}