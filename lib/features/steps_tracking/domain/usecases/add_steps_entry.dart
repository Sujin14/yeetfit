import '../repositories/steps_repository.dart';

class AddStepsEntry {
  final StepsRepository _repository;

  AddStepsEntry(this._repository);

  Future<void> call(String userId, int steps) async {
    await _repository.addStepsEntry(userId, steps);
  }
}