import '../repositories/steps_repository.dart';

class SetStepsGoal {
  final StepsRepository _repository;

  SetStepsGoal(this._repository);

  Future<void> call(String userId, int newGoal) async {
    await _repository.setStepsGoal(userId, newGoal);
  }
}
