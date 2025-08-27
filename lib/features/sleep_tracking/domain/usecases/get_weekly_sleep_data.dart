import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/sleep_model.dart';
import '../repositories/sleep_repository.dart';

class GetWeeklySleepData {
  final SleepRepository _repository;

  GetWeeklySleepData(this._repository);

  Future<AsyncValue<List<SleepData>>> call(String userId) async {
    return await _repository.getWeeklySleepData(userId);
  }
}