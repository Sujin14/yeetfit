import 'package:yeetfit/features/plans/domain/repositories/plan_repository.dart';

class ToggleFavoriteUseCase {
  final PlanRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future execute(String planId, String type, bool isFavorite) async {
    await repository.toggleFavorite(planId, type, isFavorite);
  }
}
