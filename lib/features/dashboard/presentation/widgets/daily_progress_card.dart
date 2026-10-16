import 'package:flutter/material.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/count_up_builder.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';

/// One metric tile in the dashboard's 2x2 daily progress grid.
class DailyProgressCard extends StatelessWidget {
  final String label;
  final double currentValue;
  final double goalValue;
  final String unit;
  final IconData icon;
  final ProgressLevel progressLevel;
  final VoidCallback? onTap;

  const DailyProgressCard({
    super.key,
    required this.label,
    required this.currentValue,
    required this.goalValue,
    required this.unit,
    required this.icon,
    required this.progressLevel,
    this.onTap,
  });

  static String _format(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);

  /// Keeps whole-number metrics whole while counting up.
  String _formatCounting(double shown) =>
      currentValue == currentValue.roundToDouble()
      ? shown.round().toString()
      : shown.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final ratio = goalValue > 0
        ? (currentValue / goalValue).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 20, color: colors.primary),
            // Flexible lets the 32sp number scale down on small tiles or
            // large system text sizes instead of overflowing the card.
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: CountUpBuilder(
                        value: currentValue,
                        builder: (context, shown) => Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _formatCounting(shown),
                                style: textTheme.displayLarge!.copyWith(
                                  color: colors.onBackground,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: ' / ${_format(goalValue)} $unit',
                                style: textTheme.bodySmall!.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    label,
                    style: textTheme.bodySmall!.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 4,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation(
                  colors.progressColor(progressLevel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
