import '../repositories/water_repository.dart';

class SetWaterGoal {
  final WaterRepository _repository;

  SetWaterGoal(this._repository);

  Future<void> call(String userId, int newGoal) async {
    await _repository.setWaterGoal(userId, newGoal);
  }
}
