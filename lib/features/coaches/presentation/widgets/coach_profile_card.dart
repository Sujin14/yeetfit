import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/coach.dart';
import 'coach_avatar.dart';
import 'coach_verified_badge.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Photo, name, verified badge and full bio at the top of the detail screen.
class CoachProfileCard extends StatelessWidget {
  final Coach coach;

  const CoachProfileCard({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          children: [
            CoachAvatar(
              imageUrl: coach.profileImageUrl,
              name: coach.name,
              radius: 48,
            ),
            const SizedBox(height: AppSpacing.smd),
            Text(
              coach.name.isEmpty ? 'Coach' : coach.name,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium!.copyWith(
                color: colors.onBackground,
              ),
            ),
            if (coach.isVerified) ...[
              const SizedBox(height: AppSpacing.sm),
              const CoachVerifiedBadge(showLabel: true),
            ],
            const SizedBox(height: AppSpacing.md),
            Text(
              coach.bio.isEmpty
                  ? 'This coach has not added a bio yet.'
                  : coach.bio,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium!.copyWith(
                color: coach.bio.isEmpty
                    ? colors.textMuted
                    : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
