import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../explore/presentation/providers/explore_providers.dart.dart';
import '../../data/models/plan_model.dart';
import '../../domain/use_cases/get_favorite_plans_use_case.dart';
import '../../domain/use_cases/toggle_favorite_use_case.dart';

final getFavoritePlansUseCaseProvider = Provider<GetFavoritePlansUseCase>((
  ref,
) {
  return GetFavoritePlansUseCase(ref.read(planRepositoryProvider));
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>((ref) {
  return ToggleFavoriteUseCase(ref.read(planRepositoryProvider));
});

final favoritePlansProvider = FutureProvider<List<PlanModel>>((ref) async {
  return await ref.read(getFavoritePlansUseCaseProvider).execute();
});
