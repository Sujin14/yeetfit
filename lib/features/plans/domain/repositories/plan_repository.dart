import '../../data/models/plan_model.dart';

abstract class PlanRepository {
  Future<List<PlanModel>> getAllPlans(String type);
  Future<List<PlanModel>> getFavoritePlans();
  Future<void> toggleFavorite(String planId, String type, bool isFavorite);
}