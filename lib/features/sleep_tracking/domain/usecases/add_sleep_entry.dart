
import '../repositories/sleep_repository.dart';

class AddSleepEntry {
  final SleepRepository _repository;

  AddSleepEntry(this._repository);

  Future<void> call(String userId, DateTime bedtime, DateTime wakeUpTime, double duration) async {
    await _repository.addSleepEntry(userId, bedtime, wakeUpTime, duration);
  }
}