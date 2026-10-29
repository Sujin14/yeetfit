import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/plans/data/models/plan_model.dart';
import '../providers/explore_provider.dart';
import 'explore_header.dart';
import 'explore_tab_bar.dart';
import 'plan_card_list.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ExploreBody extends ConsumerWidget {
  final AsyncValue<List<PlanModel>> plans;
  final ExploreTab selectedTab;
  final ValueChanged<ExploreTab> onTabSelected;
  final bool favoritesOnly;
  final ValueChanged<PlanModel> onPlanTap;
  final ValueChanged<PlanModel> onToggleFavorite;
  final VoidCallback onRetry;

  /// Live group sessions, shown above the tab control when not searching.
  final Widget sessionsSection;

  const ExploreBody({
    super.key,
    required this.sessionsSection,
    required this.plans,
    required this.selectedTab,
    required this.onTabSelected,
    required this.favoritesOnly,
    required this.onPlanTap,
    required this.onToggleFavorite,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchActive = ref.watch(exploreSearchActiveProvider);
    final searchQuery = ref.watch(exploreSearchQueryProvider);
    final hideSessions = searchActive && searchQuery.trim().isNotEmpty;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.deferToChild,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const SliverToBoxAdapter(child: ExploreHeader()),
          if (!hideSessions) SliverToBoxAdapter(child: sessionsSection),
          SliverToBoxAdapter(
            child: ExploreTabBar(
              selected: selectedTab,
              onSelected: onTabSelected,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            sliver: PlanCardList(
              plans: plans,
              selectedTab: selectedTab,
              favoritesOnly: favoritesOnly,
              searchQuery: searchQuery,
              onPlanTap: onPlanTap,
              onToggleFavorite: onToggleFavorite,
              onRetry: onRetry,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
