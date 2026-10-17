import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/coach.dart';
import 'coach_avatar.dart';
import 'coach_specialization_chips.dart';
import 'coach_verified_badge.dart';
import 'request_coach_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class CoachCard extends StatelessWidget {
  final Coach coach;
  final String clientUid;
  final AsyncValue<String?> currentCoachId;
  final VoidCallback onTap;

  const CoachCard({
    super.key,
    required this.coach,
    required this.clientUid,
    required this.currentCoachId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GlassCard(
        borderRadius: 20,
        padding: EdgeInsets.zero,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CoachAvatar(
                        imageUrl: coach.profileImageUrl,
                        name: coach.name,
                      ),
                      const SizedBox(width: AppSpacing.smd),
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                coach.name.isEmpty ? 'Coach' : coach.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleMedium!.copyWith(
                                  color: colors.onBackground,
                                ),
                              ),
                            ),
                            if (coach.isVerified) ...[
                              const SizedBox(width: 6),
                              const CoachVerifiedBadge(),
                            ],
                            const Spacer(),
                            if (coach.averageRating > 0)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 14,
                                    color: colors.warning,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    coach.averageRating.toStringAsFixed(1),
                                    style: textTheme.labelMedium!.copyWith(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (coach.bio.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.smd),
                    Text(
                      coach.bio,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium!.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                  if (coach.specializations.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.smd),
                    CoachSpecializationChips(
                      specializations: coach.specializations,
                      maxVisible: 3,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.smd),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RequestCoachButton(
                      coach: coach,
                      clientUid: clientUid,
                      currentCoachId: currentCoachId,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
