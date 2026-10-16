import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/food_item.dart';
import 'food_thumbnail.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class FoodResultTile extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;

  const FoodResultTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.all(AppSpacing.smd),
          child: Row(
            children: [
              FoodThumbnail(imageUrl: item.image),
              const SizedBox(width: AppSpacing.smd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.foodName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium!.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.calories.round()} kcal · '
                      'P ${item.protein.round()}g · '
                      'C ${item.carbs.round()}g · '
                      'F ${item.fat.round()}g',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
    );
  }
}
