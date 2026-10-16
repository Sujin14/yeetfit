import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class WeeklyChartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const WeeklyChartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: GlassIconButton(
        icon: Icons.bar_chart_rounded,
        color: colors.onBackground,
        tooltip: 'Weekly nutrition',
        onPressed: onPressed,
      ),
    );
  }
}
