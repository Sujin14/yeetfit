import 'package:flutter/material.dart';
import 'package:yeetfit/features/plans/domain/entities/plan_category.dart';
import 'plan_category_chip.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Favourites toggle followed by the category chips. The toggle combines
/// with whichever category is selected.
class PlanCategoryFilter extends StatelessWidget {
  final PlanCategory selected;
  final ValueChanged<PlanCategory> onSelected;
  final bool favoritesOnly;
  final VoidCallback onFavoritesToggled;

  const PlanCategoryFilter({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.favoritesOnly,
    required this.onFavoritesToggled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: PlanCategory.values.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return PlanCategoryChip(
              label: 'Favourites',
              icon: favoritesOnly ? Icons.favorite : Icons.favorite_border,
              isSelected: favoritesOnly,
              onTap: onFavoritesToggled,
            );
          }
          final category = PlanCategory.values[index - 1];
          return PlanCategoryChip(
            label: category.label,
            isSelected: category == selected,
            onTap: () => onSelected(category),
          );
        },
      ),
    );
  }
}
