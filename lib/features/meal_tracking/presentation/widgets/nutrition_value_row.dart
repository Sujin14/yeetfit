import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class NutritionValueRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;

  const NutritionValueRow({
    super.key,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.smd),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyLarge!.copyWith(color: colors.textSecondary),
            ),
          ),
          Text(
            value,
            style: textTheme.titleMedium!.copyWith(
              color: colors.onBackground,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
