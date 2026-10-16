import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Selectable chip: primary → secondary gradient when selected, glass
/// otherwise. Pass [height] for fixed-size tiles (e.g. a row of options).
class GradientSelectChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double? height;
  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle? textStyle;

  const GradientSelectChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.height,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final radius = BorderRadius.circular(borderRadius);
    final style = (textStyle ?? Theme.of(context).textTheme.labelLarge!)
        .copyWith(color: isSelected ? colors.onPrimary : colors.textSecondary);

    final content = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: padding,
            child: Center(
              heightFactor: 1,
              child: Text(label, style: style, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      selected: isSelected,
      button: true,
      child: isSelected
          ? DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.primary, colors.secondary],
                ),
              ),
              child: content,
            )
          : GlassCard(
              borderRadius: borderRadius,
              opacity: 0.1,
              padding: EdgeInsets.zero,
              child: content,
            ),
    );
  }
}
