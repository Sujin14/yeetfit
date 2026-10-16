import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/plans/data/models/plan_model.dart';
import 'package:yeetfit/features/plans/domain/entities/plan_category.dart';
import 'explore_header.dart';
import 'plan_card_list.dart';
import 'plan_category_filter.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ExploreBody extends StatelessWidget {
  final AsyncValue<List<PlanModel>> plans;
  final PlanCategory selectedCategory;
  final ValueChanged<PlanCategory> onCategorySelected;
  final bool favoritesOnly;
  final VoidCallback onFavoritesToggled;
  final ValueChanged<PlanModel> onPlanTap;
  final ValueChanged<PlanModel> onToggleFavorite;
  final VoidCallback onRetry;

  /// Live group sessions, shown above the category filter.
  final Widget sessionsSection;

  const ExploreBody({
    super.key,
    required this.sessionsSection,
    required this.plans,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.favoritesOnly,
    required this.onFavoritesToggled,
    required this.onPlanTap,
    required this.onToggleFavorite,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: ExploreHeader()),
        SliverToBoxAdapter(child: sessionsSection),
        SliverToBoxAdapter(
          child: PlanCategoryFilter(
            selected: selectedCategory,
            onSelected: onCategorySelected,
            favoritesOnly: favoritesOnly,
            onFavoritesToggled: onFavoritesToggled,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          sliver: PlanCardList(
            plans: plans,
            selectedCategory: selectedCategory,
            favoritesOnly: favoritesOnly,
            onPlanTap: onPlanTap,
            onToggleFavorite: onToggleFavorite,
            onRetry: onRetry,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
