import 'package:yeetfit/features/plans/data/repositories/plan_repository.dart';
import 'package:yeetfit/features/plans/data/models/plan_model.dart';

class GetFavoritePlansUseCase {
  final PlanRepository repository;

  GetFavoritePlansUseCase(this.repository);

  Future<List<PlanModel>> execute() async {
    return await repository.getFavoritePlans();
  }
}
