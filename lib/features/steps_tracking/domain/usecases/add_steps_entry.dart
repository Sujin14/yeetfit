import '../repositories/steps_repository.dart';

// Use case for adding steps entry.
class AddStepsEntry {
  final StepsRepository _repository;

  const AddStepsEntry(this._repository);

  Future<void> call(String userId, int steps) async {
    await _repository.addStepsEntry(userId, steps);
  }
}
