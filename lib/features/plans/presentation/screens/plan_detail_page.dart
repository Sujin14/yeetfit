import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/plan_detail_controller.dart';
import '../providers/plan_provider.dart';
import '../widgets/plan_detail_shimmer.dart';
import '../widgets/plan_detail_status_view.dart';
import '../widgets/plan_detail_view.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class PlanDetailPage extends ConsumerWidget {
  final String category;
  final String planId;

  const PlanDetailPage({
    super.key,
    required this.category,
    required this.planId,
  });

  void _showSnackBar(BuildContext context, String message, Color background) {
    final colors = Theme.of(context).extension<AppColors>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: colors.onBackground),
        ),
        backgroundColor: background,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final detailKey = (category: category, planId: planId);

    ref.listen(planDetailControllerProvider, (_, event) {
      switch (event) {
        case PlanFavoriteToggled(:final isFavorite):
          _showSnackBar(
            context,
            isFavorite ? 'Added to favorites' : 'Removed from favorites',
            colors.primary,
          );
        case PlanFavoriteToggleFailed(:final message):
          _showSnackBar(context, message, colors.error);
        case null:
          return;
      }
      ref.read(planDetailControllerProvider.notifier).consume();
    });

    final planAsync = ref.watch(planDetailProvider(detailKey));

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: planAsync.when(
          data: (updatedPlan) => updatedPlan == null
              ? const PlanDetailStatusView(
                  title: 'Plan',
                  child: YeetErrorState(
                    message: 'This plan is no longer available.',
                  ),
                )
              : PlanDetailView(
                  plan: updatedPlan,
                  onToggleFavorite: () => ref
                      .read(planDetailControllerProvider.notifier)
                      .toggleFavorite(updatedPlan),
                  onStartPlan: () => _showSnackBar(
                    context,
                    'Workout tracking for plans is coming soon',
                    colors.surface,
                  ),
                ),
          loading: () => const PlanDetailStatusView(
            title: 'Plan',
            child: PlanDetailShimmer(),
          ),
          error: (error, _) => PlanDetailStatusView(
            title: 'Plan',
            child: YeetErrorState(
              message: 'Could not load this plan: $error',
              onRetry: () => ref.invalidate(planDetailProvider(detailKey)),
            ),
          ),
        ),
      ),
    );
  }
}
