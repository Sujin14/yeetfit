import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/gradient_select_chip.dart';
import '../utils/meal_types.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class MealTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const MealTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final mealType in mealTypes)
          GradientSelectChip(
            label: mealType,
            isSelected: mealType == selected,
            onTap: () => onSelected(mealType),
          ),
      ],
    );
  }
}
