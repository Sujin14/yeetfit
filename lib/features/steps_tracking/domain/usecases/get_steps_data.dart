import '../../data/model/steps_model.dart';
import '../repositories/steps_repository.dart';

// Use case for fetching steps data.
class GetStepsData {
  final StepsRepository _repository;

  const GetStepsData(this._repository);

  Future<StepsData?> call(String userId, String date) async {
    return await _repository.getStepsData(userId, date);
  }
}