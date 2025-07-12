import '../models/plan_model.dart';

abstract class PlanRepository {
  Future<PlanModel?> getPlan(String type);
  Future<List<PlanModel>> getFavoritePlans();
  Future<void> toggleFavorite(String planId, String type, bool isFavorite);
}