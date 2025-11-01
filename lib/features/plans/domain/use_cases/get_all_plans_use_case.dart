import 'package:yeetfit/features/plans/data/models/plan_model.dart';
import 'package:yeetfit/features/plans/domain/repositories/plan_repository.dart';

class GetAllPlansUseCase {
  final PlanRepository repository;
  GetAllPlansUseCase(this.repository);
  Future<List<PlanModel>> execute(String type) async {
    try {
      return await repository.getAllPlans(type);
    } catch (e) {
      throw Exception('Failed to get $type plans:$e');
    }
  }
}
