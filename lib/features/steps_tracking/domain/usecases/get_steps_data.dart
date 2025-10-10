import '../../data/model/steps_model.dart';
import '../repositories/steps_repository.dart';

class GetStepsData {
  final StepsRepository _repository;

  GetStepsData(this._repository);

  Future<StepsData?> call(String userId, String date) async {
    return await _repository.getStepsData(userId, date);
  }
}
