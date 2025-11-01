import '../repositories/plan_repository.dart';
import '../../data/models/plan_model.dart';

class GetFavoritePlansUseCase {
  final PlanRepository repository;

  GetFavoritePlansUseCase(this.repository);

  Future<List<PlanModel>> execute() async {
    try {
      return await repository.getFavoritePlans();
    } catch (e) {
      throw Exception('Failed to get favorite plans: $e');
    }
  }
}