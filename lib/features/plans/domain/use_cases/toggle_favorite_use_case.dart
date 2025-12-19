import '../repositories/plan_repository.dart';

class ToggleFavoriteUseCase {
  final PlanRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> execute(String planId, String type, bool isFavorite) async {
    try {
      await repository.toggleFavorite(planId, type, isFavorite);
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }
}