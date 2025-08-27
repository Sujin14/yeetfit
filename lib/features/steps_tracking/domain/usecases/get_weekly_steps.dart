import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/steps_model.dart';
import '../repositories/steps_repository.dart';

class GetWeeklyStepsData {
  final StepsRepository _repository;

  GetWeeklyStepsData(this._repository);

  Future<AsyncValue<List<StepsData>>> call(String userId) async {
    return await _repository.getWeeklyStepsData(userId);
  }
}