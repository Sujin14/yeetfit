import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/plans/data/models/plan_model.dart';
import 'package:yeetfit/features/plans/presentation/providers/plan_detail_controller.dart';
import 'package:yeetfit/features/plans/presentation/providers/plan_provider.dart';

enum ExploreTab { diet, workout }

final exploreTabProvider = NotifierProvider<ExploreTabNotifier, ExploreTab>(
  ExploreTabNotifier.new,
);

class ExploreTabNotifier extends Notifier<ExploreTab> {
  @override
  ExploreTab build() => ExploreTab.diet;

  void select(ExploreTab tab) => state = tab;
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

final exploreSearchActiveProvider =
    NotifierProvider<ExploreSearchActiveNotifier, bool>(
      ExploreSearchActiveNotifier.new,
    );

class ExploreSearchActiveNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setActive(bool value) => state = value;
}

final exploreSearchQueryProvider =
    NotifierProvider<ExploreSearchQueryNotifier, String>(
      ExploreSearchQueryNotifier.new,
    );

class ExploreSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;

  void clear() => state = '';
}

/// Plans for the active Explore tab, optionally favourites-only and searched.
final explorePlansProvider = Provider<AsyncValue<List<PlanModel>>>((ref) {
  final tab = ref.watch(exploreTabProvider);
  final favoritesOnly = ref.watch(showFavoritesOnlyProvider);
  final query = ref.watch(exploreSearchQueryProvider).trim().toLowerCase();
  final source = ref.watch(
    tab == ExploreTab.diet ? allDietPlansProvider : allWorkoutPlansProvider,
  );

  return source.when(
    data: (plans) {
      var filtered = favoritesOnly
          ? plans.where((plan) => plan.isFavorite).toList()
          : List<PlanModel>.from(plans);

      if (query.isNotEmpty) {
        filtered = filtered.where((plan) {
          if (plan.title.toLowerCase().contains(query)) return true;
          final description = plan.details['description'];
          return description is String &&
              description.toLowerCase().contains(query);
        }).toList();
      }

      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return AsyncData(filtered);
    },
    loading: () => const AsyncLoading(),
    error: AsyncError.new,
  );
});

/// Separate instance from the detail page's controller so a favourite toggled
/// on Explore isn't also reported by a detail page listener (and vice versa).
final exploreFavoriteControllerProvider =
    NotifierProvider.autoDispose<PlanDetailController, PlanDetailEvent?>(
      PlanDetailController.new,
    );
