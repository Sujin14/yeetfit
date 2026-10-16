import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/plan_provider.dart';
import '../widgets/plan_favorites_toggle.dart';
import '../widgets/plan_list_app_bar.dart';
import '../widgets/plan_list_message.dart';
import '../widgets/plan_list_shimmer.dart';
import '../widgets/plan_list_view.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/routes/plans_route_constants.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class PlanListScreen extends ConsumerWidget {
  final String category;

  const PlanListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDiet = category == 'diet';
    final label = isDiet ? 'diet' : 'workout';
    final favoritesOnly = ref.watch(planListFavoritesOnlyProvider(category));
    final plansAsync = ref.watch(planListPlansProvider(category));

    return Scaffold(
      appBar: PlanListAppBar(
        title: isDiet ? 'Diet Plans' : 'Workout Plans',
        actions: [
          PlanFavoritesToggle(
            isActive: favoritesOnly,
            onToggle: () => ref
                .read(planListFavoritesOnlyProvider(category).notifier)
                .toggle(),
          ),
          const SizedBox(width: AppSpacing.smd),
        ],
      ),
      body: SafeArea(
        child: plansAsync.when(
          data: (plans) => plans.isEmpty
              ? PlanListMessage(
                  message: favoritesOnly
                      ? 'No favourite $label plans yet.'
                      : 'No $label plans have been assigned.',
                  color: colors.onSurface.withValues(alpha: 0.8),
                )
              : PlanListView(
                  plans: plans,
                  onPlanTap: (plan) {
                    final planId = plan.id;
                    if (planId == null) return;
                    context.push(
                      PlansRouteConstants.detailPath(category, planId),
                    );
                  },
                ),
          loading: () => const PlanListShimmer(),
          error: (error, _) => YeetErrorState(
            message: 'Could not load plans: $error',
            onRetry: () => ref
              ..invalidate(
                isDiet ? allDietPlansProvider : allWorkoutPlansProvider,
              )
              ..invalidate(favoritePlansProvider),
          ),
        ),
      ),
    );
  }
}
