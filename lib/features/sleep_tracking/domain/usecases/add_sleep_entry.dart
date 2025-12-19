import '../repositories/sleep_repository.dart';

// Use case for adding sleep entry.
class AddSleepEntry {
  final SleepRepository _repository;

  const AddSleepEntry(this._repository);

  Future<void> call(String userId, DateTime bedtime, DateTime wakeUpTime, double duration) async {
    await _repository.addSleepEntry(userId, bedtime, wakeUpTime, duration);
  }
}