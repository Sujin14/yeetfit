import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../plans/data/models/plan_model.dart';
import '../../../plans/data/repositories/plan_repository.dart';
import '../../../plans/data/repositories/plan_repository_impl.dart';
import '../../../plans/domain/use_cases/get_favorite_plans_use_case.dart';
import '../../../plans/domain/use_cases/toggle_favorite_use_case.dart';
import '../../domain/use_cases/get_plans_use_case.dart';


final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepositoryImpl();
});

final getPlanUseCaseProvider = Provider<GetPlansUseCase>((ref) {
  return GetPlansUseCase(ref.read(planRepositoryProvider));
});

final getFavoritePlansUseCaseProvider = Provider<GetFavoritePlansUseCase>((ref) {
  return GetFavoritePlansUseCase(ref.read(planRepositoryProvider));
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>((ref) {
  return ToggleFavoriteUseCase(ref.read(planRepositoryProvider));
});

final dietPlanProvider = FutureProvider<PlanModel?>((ref) async {
  return await ref.read(getPlanUseCaseProvider).execute('diets');
});

final workoutPlanProvider = FutureProvider<PlanModel?>((ref) async {
  return await ref.read(getPlanUseCaseProvider).execute('workouts');
});

final favoritePlansProvider = FutureProvider<List<PlanModel>>((ref) async {
  return await ref.read(getFavoritePlansUseCaseProvider).execute();
});