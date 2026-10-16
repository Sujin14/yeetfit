import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_bottom_nav_bar.dart';
import '../../domain/entities/coach.dart';
import 'coach_discovery_header.dart';
import 'coach_list_sliver.dart';
import 'coach_search_field.dart';
import 'my_coach_card.dart';

class CoachDiscoveryBody extends StatelessWidget {
  final AsyncValue<List<Coach>> coaches;
  final String clientUid;
  final AsyncValue<String?> currentCoachId;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<Coach> onOpen;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final VoidCallback onCoachRemoved;

  const CoachDiscoveryBody({
    super.key,
    required this.coaches,
    required this.clientUid,
    required this.currentCoachId,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onOpen,
    required this.onRetry,
    required this.onRefresh,
    required this.onCoachRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: colors.primary,
      backgroundColor: colors.surface,
      child: CustomScrollView(
        // Pull-to-refresh must work even when the list is shorter than the
        // screen.
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const SliverToBoxAdapter(child: CoachDiscoveryHeader()),
          SliverToBoxAdapter(
            child: MyCoachCard(
              clientUid: clientUid,
              onOpen: onOpen,
              onRemoved: onCoachRemoved,
            ),
          ),
          SliverToBoxAdapter(
            child: CoachSearchField(onChanged: onSearchChanged),
          ),
          CoachListSliver(
            coaches: coaches,
            clientUid: clientUid,
            currentCoachId: currentCoachId,
            searchQuery: searchQuery,
            onOpen: onOpen,
            onRetry: onRetry,
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: GlassBottomNavBar.contentClearance),
          ),
        ],
      ),
    );
  }
}
