import '../repositories/sleep_repository.dart';

// Use case for setting sleep goal.
class SetSleepGoal {
  final SleepRepository _repository;

  const SetSleepGoal(this._repository);

  Future<void> call(String userId, double newGoal) async {
    await _repository.setSleepGoal(userId, newGoal);
  }
}