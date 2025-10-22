import '../../data/model/sleep_model.dart';
import '../repositories/sleep_repository.dart';

// Use case for fetching weekly sleep data.
class GetWeeklySleepData {
  final SleepRepository _repository;

  const GetWeeklySleepData(this._repository);

  Future<List<SleepData>> call(String userId) async {
    return await _repository.getWeeklySleepData(userId);
  }
}