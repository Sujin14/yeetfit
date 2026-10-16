import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/features/plans/data/models/plan_model.dart';
import 'package:yeetfit/features/plans/presentation/utils/plan_display.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'plan_category_badge.dart';
import 'plan_thumbnail.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const PlanCard({
    super.key,
    required this.plan,
    required this.onTap,
    required this.onToggleFavorite,
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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium!.copyWith(
                                color: colors.onBackground,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            PlanCategoryBadge(label: plan.categoryLabel),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              plan.metaLine,
                              style: textTheme.bodySmall!.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.smd),
                      PlanThumbnail(
                        imageUrl: plan.thumbnailUrl,
                        fallbackIcon: plan.categoryIcon,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    onPressed: onToggleFavorite,
                    tooltip: plan.isFavorite
                        ? 'Remove from favourites'
                        : 'Add to favourites',
                    style: IconButton.styleFrom(
                      backgroundColor: colors.background.withValues(
                        alpha: 0.45,
                      ),
                      minimumSize: const Size.square(32),
                      padding: EdgeInsets.zero,
                    ),
                    icon: Icon(
                      plan.isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: plan.isFavorite
                          ? colors.error
                          : colors.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
