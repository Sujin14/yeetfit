import '../repositories/weight_repository.dart';

class SetWeightGoal {
  final WeightRepository _repository;

  SetWeightGoal(this._repository);

  Future<void> call(String userId, double goalWeight, double initialWeight, DateTime? targetDate) async {
    await _repository.setUserWeightGoal(userId, goalWeight, initialWeight, targetDate);
  }
}