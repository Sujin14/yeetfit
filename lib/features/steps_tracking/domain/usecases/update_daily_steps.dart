import '../repositories/steps_repository.dart';

// Use case for updating daily steps.
class UpdateDailySteps {
  final StepsRepository _repository;

  const UpdateDailySteps(this._repository);

  Future<void> call(String userId, String date, int steps) async {
    await _repository.updateDailySteps(userId, date, steps);
  }
}