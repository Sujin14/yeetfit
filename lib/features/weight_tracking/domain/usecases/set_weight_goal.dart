import '../repositories/weight_repository.dart';

// Use case for setting weight goal.
class SetWeightGoal {
  final WeightRepository _repository;

  const SetWeightGoal(this._repository);

  Future<void> call(String userId, double goalWeight, double initialWeight, DateTime? targetDate) async {
    await _repository.setUserWeightGoal(userId, goalWeight, initialWeight, targetDate);
  }
}