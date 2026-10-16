import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/features/challenges/presentation/providers/challenge_provider.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/shimmer_line.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Entry point to Community Challenges with a live participation hint.
class DashboardChallengesCard extends ConsumerWidget {
  final VoidCallback onOpen;

  const DashboardChallengesCard({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final String? hint = ref
        .watch(activeChallengesProvider)
        .when(
          data: (challenges) {
            if (challenges.isEmpty) return 'New challenges coming soon';
            final participants = challenges.fold<int>(
              0,
              (total, challenge) => total + challenge.participantCount,
            );
            final active = challenges.length == 1
                ? '1 active challenge'
                : '${challenges.length} active challenges';
            return '$active · $participants participants';
          },
          loading: () => null,
          error: (_, _) => 'Compete with the community',
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colors.primary, colors.secondary],
                      ),
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: colors.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community Challenges',
                          style: textTheme.titleMedium!.copyWith(
                            color: colors.onBackground,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (hint == null)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: ShimmerLine(height: 12, width: 160),
                          )
                        else
                          Text(
                            hint,
                            style: textTheme.bodySmall!.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: colors.textMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
