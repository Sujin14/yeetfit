import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/coach.dart';
import 'coach_card.dart';
import 'coach_list_shimmer.dart';
import 'coach_message_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class CoachListSliver extends StatelessWidget {
  final AsyncValue<List<Coach>> coaches;
  final String clientUid;
  final AsyncValue<String?> currentCoachId;
  final String searchQuery;
  final ValueChanged<Coach> onOpen;
  final VoidCallback onRetry;

  const CoachListSliver({
    super.key,
    required this.coaches,
    required this.clientUid,
    required this.currentCoachId,
    required this.searchQuery,
    required this.onOpen,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return coaches.when(
      data: (items) => items.isEmpty
          ? SliverToBoxAdapter(
              child: searchQuery.trim().isEmpty
                  ? const CoachMessageCard(
                      imageAsset: 'assets/images/empty_coaches.webp',
                      message:
                          'No coaches are available right now. '
                          'Check back soon!',
                    )
                  : CoachMessageCard(
                      icon: Icons.person_search_outlined,
                      message: 'No coaches match "${searchQuery.trim()}".',
                    ),
            )
          : SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              sliver: SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => CoachCard(
                  key: ValueKey(items[index].uid),
                  coach: items[index],
                  clientUid: clientUid,
                  currentCoachId: currentCoachId,
                  onTap: () => onOpen(items[index]),
                ),
              ),
            ),
      loading: () => const SliverToBoxAdapter(child: CoachListShimmer()),
      error: (_, _) => SliverToBoxAdapter(
        child: YeetErrorState(
          message: "Couldn't load coaches.",
          onRetry: onRetry,
        ),
      ),
    );
  }
}
