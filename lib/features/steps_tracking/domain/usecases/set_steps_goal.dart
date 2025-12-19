import '../repositories/steps_repository.dart';

// Use case for setting steps goal.
class SetStepsGoal {
  final StepsRepository _repository;

  const SetStepsGoal(this._repository);

  Future<void> call(String userId, int newGoal) async {
    await _repository.setStepsGoal(userId, newGoal);
  }
}
