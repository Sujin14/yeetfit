import '../repositories/sleep_repository.dart';

class SetSleepGoal {
  final SleepRepository _repository;

  SetSleepGoal(this._repository);

  Future<void> call(String userId, double newGoal) async {
    await _repository.setSleepGoal(userId, newGoal);
  }
}