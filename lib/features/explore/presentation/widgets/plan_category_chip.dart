import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Filter chip: gradient when selected, frosted glass otherwise.
class PlanCategoryChip extends StatelessWidget {
  static const double _radius = 20;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  );

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const PlanCategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
      color: isSelected ? colors.onPrimary : colors.textSecondary,
    );
    final content = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        child: Padding(
          padding: _padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon case final icon?) ...[
                Icon(icon, size: 16, color: textStyle.color),
                const SizedBox(width: 6),
              ],
              Text(label, style: textStyle),
            ],
          ),
        ),
      ),
    );

    if (isSelected) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.secondary],
          ),
        ),
        child: content,
      );
    }
    return GlassCard(
      borderRadius: _radius,
      opacity: 0.1,
      padding: EdgeInsets.zero,
      child: content,
    );
  }
}
