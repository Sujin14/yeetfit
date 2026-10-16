import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/plans/data/models/plan_model.dart';
import 'package:yeetfit/features/plans/domain/entities/plan_category.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import 'explore_message_card.dart';
import 'explore_shimmer.dart';
import 'plan_card.dart';

/// Sliver list of plan cards with loading, empty and error states.
class PlanCardList extends StatelessWidget {
  final AsyncValue<List<PlanModel>> plans;
  final PlanCategory selectedCategory;
  final bool favoritesOnly;
  final ValueChanged<PlanModel> onPlanTap;
  final ValueChanged<PlanModel> onToggleFavorite;
  final VoidCallback onRetry;

  const PlanCardList({
    super.key,
    required this.plans,
    required this.selectedCategory,
    required this.favoritesOnly,
    required this.onPlanTap,
    required this.onToggleFavorite,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return switch (plans) {
      AsyncData(:final value) when value.isEmpty => SliverToBoxAdapter(
        child: ExploreMessageCard(
          imageAsset: 'assets/images/empty_plans.webp',
          message: switch ((favoritesOnly, selectedCategory)) {
            (true, PlanCategory.all) =>
              'No favourite plans yet. Tap the heart on a plan to save it.',
            (true, final category) => 'No favourite ${category.label} plans.',
            (false, PlanCategory.all) =>
              'No plans have been assigned to you yet.',
            (false, final category) => 'No ${category.label} plans yet.',
          },
        ),
      ),
      AsyncData(:final value) => SliverList.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          final plan = value[index];
          return PlanCard(
            plan: plan,
            onTap: () => onPlanTap(plan),
            onToggleFavorite: () => onToggleFavorite(plan),
          );
        },
      ),
      AsyncError(:final error) => SliverToBoxAdapter(
        child: YeetErrorState(
          message: error.toString().contains('PERMISSION_DENIED')
              ? 'Permission denied: Please check your authentication'
              : '$error',
          onRetry: onRetry,
        ),
      ),
      _ => const SliverToBoxAdapter(child: ExploreShimmer()),
    };
  }
}
