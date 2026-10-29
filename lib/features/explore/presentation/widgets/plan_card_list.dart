import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/plans/data/models/plan_model.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/explore_provider.dart';
import 'explore_message_card.dart';
import 'explore_shimmer.dart';
import 'plan_card.dart';

/// Sliver list of plan cards with loading, empty and error states.
class PlanCardList extends StatelessWidget {
  final AsyncValue<List<PlanModel>> plans;
  final ExploreTab selectedTab;
  final bool favoritesOnly;
  final String searchQuery;
  final ValueChanged<PlanModel> onPlanTap;
  final ValueChanged<PlanModel> onToggleFavorite;
  final VoidCallback onRetry;

  const PlanCardList({
    super.key,
    required this.plans,
    required this.selectedTab,
    required this.favoritesOnly,
    required this.searchQuery,
    required this.onPlanTap,
    required this.onToggleFavorite,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final trimmedQuery = searchQuery.trim();

    return switch (plans) {
      AsyncData(:final value) when value.isEmpty => SliverToBoxAdapter(
        child: ExploreMessageCard(
          imageAsset: 'assets/images/empty_plans.webp',
          message: trimmedQuery.isNotEmpty
              ? selectedTab == ExploreTab.diet
                    ? 'No diet plans match "$trimmedQuery"'
                    : 'No workout plans match "$trimmedQuery"'
              : switch ((favoritesOnly, selectedTab)) {
                  (true, ExploreTab.diet) => 'No favourite diet plans yet',
                  (true, ExploreTab.workout) =>
                    'No favourite workout plans yet',
                  (false, ExploreTab.diet) => 'No diet plans assigned yet',
                  (false, ExploreTab.workout) =>
                    'No workout plans assigned yet',
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
