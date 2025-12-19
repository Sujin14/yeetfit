import '../../data/model/sleep_model.dart';
import '../repositories/sleep_repository.dart';

// Use case for fetching sleep data.
class GetSleepData {
  final SleepRepository _repository;

  const GetSleepData(this._repository);

  Future<SleepData?> call(String userId) async {
    return await _repository.getSleepData(userId);
  }
}