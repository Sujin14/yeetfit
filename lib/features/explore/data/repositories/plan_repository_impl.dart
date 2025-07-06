import '../../../plans/data/data_sources/firestore_data_source.dart';
import '../../../plans/data/models/plan_model.dart';
import 'plan_repository.dart';

class PlanRepositoryImpl implements PlanRepository {
  final FirestoreDataSource dataSource;

  PlanRepositoryImpl({FirestoreDataSource? dataSource})
    : dataSource = dataSource ?? FirestoreDataSource();

  @override
  Future<PlanModel?> getPlan(String type) async {
    return await dataSource.getPlan(type);
  }

  @override
  Future<List<PlanModel>> getFavoritePlans() async {
    return await dataSource.getFavoritePlans();
  }

  @override
  Future<void> toggleFavorite(
    String planId,
    String type,
    bool isFavorite,
  ) async {
    await dataSource.toggleFavorite(planId, type, isFavorite);
  }
}
