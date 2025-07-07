import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../plans/data/models/plan_model.dart';
import '../../../plans/data/repositories/plan_repository.dart';
import '../../../plans/data/repositories/plan_repository_impl.dart';
import '../../domain/use_cases/get_plans_use_case.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepositoryImpl();
});

final getPlanUseCaseProvider = Provider<GetPlansUseCase>((ref) {
  return GetPlansUseCase(ref.read(planRepositoryProvider));
});

final dietPlanProvider = FutureProvider<PlanModel?>((ref) async {
  return await ref.read(getPlanUseCaseProvider).execute('diets');
});

final workoutPlanProvider = FutureProvider<PlanModel?>((ref) async {
  return await ref.read(getPlanUseCaseProvider).execute('workouts');
});
