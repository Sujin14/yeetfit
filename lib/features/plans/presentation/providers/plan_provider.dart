import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import '../../data/data_sources/firestore_data_source.dart';
import '../../data/models/plan_model.dart';

final planDataSourceProvider = Provider<FirestoreDataSource>(
  (ref) => FirestoreDataSource(),
);

final allDietPlansProvider = StreamProvider<List<PlanModel>>((ref) {
  final userId = ref.watch(authUserIdProvider);
  if (userId == null) return Stream.value(const []);
  return ref
      .read(planDataSourceProvider)
      .watchPlans(userId, collection: 'diets', type: 'diet');
});

final allWorkoutPlansProvider = StreamProvider<List<PlanModel>>((ref) {
  final userId = ref.watch(authUserIdProvider);
  if (userId == null) return Stream.value(const []);
  return ref
      .read(planDataSourceProvider)
      .watchPlans(userId, collection: 'workouts', type: 'workout');
});

final favoritePlansProvider = FutureProvider<List<PlanModel>>((ref) {
  // Refetch when the signed-in account changes.
  ref.watch(authUserIdProvider);
  return ref.read(planDataSourceProvider).getFavoritePlans();
});

/// Favourites filter for one plan list screen ([category] is `diet` or
/// `workouts`); resets when the screen closes.
final planListFavoritesOnlyProvider = NotifierProvider.autoDispose
    .family<PlanListFavoritesOnlyNotifier, bool, String>(
      PlanListFavoritesOnlyNotifier.new,
    );

class PlanListFavoritesOnlyNotifier extends Notifier<bool> {
  final String category;

  PlanListFavoritesOnlyNotifier(this.category);

  @override
  bool build() => false;

  void toggle() => state = !state;
}

/// Plans shown on a list screen: every plan of [category], or only its
/// favourites while the filter is on.
final planListPlansProvider = Provider.autoDispose
    .family<AsyncValue<List<PlanModel>>, String>((ref, category) {
      final isDiet = category == 'diet';
      if (!ref.watch(planListFavoritesOnlyProvider(category))) {
        return ref.watch(
          isDiet ? allDietPlansProvider : allWorkoutPlansProvider,
        );
      }
      return ref
          .watch(favoritePlansProvider)
          .whenData(
            (plans) =>
                plans.where((plan) => (plan.type == 'diet') == isDiet).toList(),
          );
    });

/// The route category picks the collection; plan IDs are only unique within
/// one, so both are part of the key.
typedef PlanDetailKey = ({String category, String planId});

/// One plan, live. `null` once it's deleted or no longer visible.
final planDetailProvider = StreamProvider.autoDispose
    .family<PlanModel?, PlanDetailKey>((ref, key) {
      final userId = ref.watch(authUserIdProvider);
      if (userId == null) return Stream.value(null);
      return ref
          .read(planDataSourceProvider)
          .watchPlan(
            userId,
            collection: key.category == 'diet' ? 'diets' : 'workouts',
            planId: key.planId,
          );
    });
