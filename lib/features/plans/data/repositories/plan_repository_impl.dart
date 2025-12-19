import '../../domain/repositories/plan_repository.dart';
import '../data_sources/firestore_data_source.dart';
import '../models/plan_model.dart';

class PlanRepositoryImpl implements PlanRepository {
  final FirestoreDataSource dataSource;

  PlanRepositoryImpl({FirestoreDataSource? dataSource})
      : dataSource = dataSource ?? FirestoreDataSource();


  @override
  Future<List<PlanModel>> getAllPlans(String type) async {
    return await dataSource.getAllPlans(type);
  }

  @override
  Future<List<PlanModel>> getFavoritePlans() async {
    return await dataSource.getFavoritePlans();
  }

  @override
  Future<void> toggleFavorite(String planId, String type, bool isFavorite) async {
    await dataSource.toggleFavorite(planId, type, isFavorite);
  }
}