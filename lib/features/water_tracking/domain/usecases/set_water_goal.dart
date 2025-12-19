import '../repositories/water_repository.dart';

// Use case for setting water goal.
class SetWaterGoal {
  final WaterRepository _repository;

  const SetWaterGoal(this._repository);

  Future<void> call(String userId, int newGoal) async {
    await _repository.setWaterGoal(userId, newGoal);
  }
}