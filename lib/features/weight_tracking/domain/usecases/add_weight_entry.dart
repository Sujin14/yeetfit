import '../repositories/weight_repository.dart';

// Use case for adding a weight entry.
class AddWeightEntry {
  final WeightRepository _repository;

  const AddWeightEntry(this._repository);

  Future<void> call(
    String userId,
    String date,
    double currentWeight,
    double goalWeight,
    double initialWeight,
    DateTime? targetDate,
  ) async {
    await _repository.addWeightEntry(userId, date, currentWeight, goalWeight, initialWeight, targetDate);
  }
}