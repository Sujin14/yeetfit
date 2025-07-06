import '../../../plans/data/models/plan_model.dart';
import '../../data/repositories/plan_repository.dart';

class GetPlansUseCase {
  final PlanRepository repository;

  GetPlansUseCase(this.repository);

  Future<PlanModel?> execute(String type) async {
    return await repository.getPlan(type);
  }
}
