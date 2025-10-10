import '../repositories/steps_repository.dart';

class UpdateDailySteps {
  final StepsRepository _repository;

  UpdateDailySteps(this._repository);

  Future<void> call(String userId, String date, int steps) async {
    await _repository.updateDailySteps(userId, date, steps);
  }
}
