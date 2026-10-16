import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/plans/data/models/plan_model.dart';
import 'package:yeetfit/features/plans/domain/entities/plan_category.dart';
import 'package:yeetfit/features/plans/presentation/providers/plan_detail_controller.dart';
import 'package:yeetfit/features/plans/presentation/providers/plan_provider.dart';
import 'package:yeetfit/features/plans/presentation/utils/plan_display.dart';

final selectedPlanCategoryProvider =
    NotifierProvider<SelectedPlanCategoryNotifier, PlanCategory>(
      SelectedPlanCategoryNotifier.new,
    );

class SelectedPlanCategoryNotifier extends Notifier<PlanCategory> {
  @override
  PlanCategory build() => PlanCategory.all;

  void select(PlanCategory category) => state = category;
}

final showFavoritesOnlyProvider =
    NotifierProvider<ShowFavoritesOnlyNotifier, bool>(
      ShowFavoritesOnlyNotifier.new,
    );

class ShowFavoritesOnlyNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

/// Workout and diet plans merged (newest first) and filtered client-side by
/// [selectedPlanCategoryProvider]. With [showFavoritesOnlyProvider] on, the
/// source is the `isFavorite == true` query instead.
final explorePlansProvider = Provider<AsyncValue<List<PlanModel>>>((ref) {
  final selected = ref.watch(selectedPlanCategoryProvider);
  final sources = ref.watch(showFavoritesOnlyProvider)
      ? [ref.watch(favoritePlansProvider)]
      : [ref.watch(allWorkoutPlansProvider), ref.watch(allDietPlansProvider)];

  // A refresh after each favourite toggle keeps the previous value, so the
  // list doesn't flash back to the shimmer.
  final plans = <PlanModel>[];
  for (final source in sources) {
    final value = source.value;
    if (value == null) {
      if (source case AsyncError(:final error, :final stackTrace)) {
        return AsyncError(error, stackTrace);
      }
      return const AsyncLoading();
    }
    plans.addAll(value);
  }

  plans.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return AsyncData(
    selected == PlanCategory.all
        ? plans
        : plans.where((plan) => plan.category == selected).toList(),
  );
});

/// Separate instance from the detail page's controller so a favourite toggled
/// on Explore isn't also reported by a detail page listener (and vice versa).
final exploreFavoriteControllerProvider =
    NotifierProvider.autoDispose<PlanDetailController, PlanDetailEvent?>(
      PlanDetailController.new,
    );
