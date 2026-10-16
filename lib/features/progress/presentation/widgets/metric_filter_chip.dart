import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Pill chip in [MetricFilterRow]: gradient when selected, glass otherwise.
class MetricFilterChip extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool isSelected;
  final VoidCallback? onTap;

  const MetricFilterChip({
    super.key,
    required this.icon,
    this.label,
    this.isSelected = false,
    this.onTap,
  });

  static const double _radius = 20;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final foreground = isSelected ? Colors.white : colors.onBackground;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: foreground),
        if (label != null) ...[
          const SizedBox(width: 6),
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: foreground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );

    final chip = isSelected
        ? Container(
            padding: _padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              gradient: LinearGradient(
                colors: [colors.primary, colors.secondary],
              ),
            ),
            child: content,
          )
        : GlassCard(
            borderRadius: _radius,
            padding: _padding,
            color: Colors.white,
            opacity: 0.1,
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            child: content,
          );

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Semantics(
        button: onTap != null,
        selected: isSelected,
        child: GestureDetector(onTap: onTap, child: chip),
      ),
    );
  }
}
