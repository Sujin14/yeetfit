import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../../domain/entities/food_item.dart';
import 'food_thumbnail.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class NutritionHeader extends StatelessWidget {
  final FoodItem foodItem;

  const NutritionHeader({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.md,
      ),
      child: Column(
        children: [
          FoodThumbnail(imageUrl: foodItem.image, size: 112),
          const SizedBox(height: AppSpacing.md),
          Text(
            foodItem.foodName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineMedium!.copyWith(
              color: colors.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${foodItem.quantity.round()} g · ${foodItem.mealType}',
            style: textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
