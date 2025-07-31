import '../../data/model/sleep_model.dart';
import '../repositories/sleep_repository.dart';

class GetSleepData {
  final SleepRepository _repository;

  GetSleepData(this._repository);

  Future<SleepData?> call(String userId) async {
    return await _repository.getSleepData(userId);
  }
}