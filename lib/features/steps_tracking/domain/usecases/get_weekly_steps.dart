import '../../data/model/steps_model.dart';
import '../repositories/steps_repository.dart';

// Use case for fetching weekly steps data.
class GetWeeklyStepsData {
  final StepsRepository _repository;

  const GetWeeklyStepsData(this._repository);

  Future<List<StepsData>> call(String userId) async {
    return await _repository.getWeeklyStepsData(userId);
  }
}