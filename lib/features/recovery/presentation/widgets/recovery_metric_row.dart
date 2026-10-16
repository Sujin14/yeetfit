import 'package:flutter/material.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// One metric in the recovery breakdown: icon, label, points and a bar.
class RecoveryMetricRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final double max;

  const RecoveryMetricRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final ratio = max > 0 ? (value / max).clamp(0.0, 1.0) : 0.0;
    final barColor = colors.progressColor(ProgressLevel.fromRatio(ratio));

    return Row(
      children: [
        Icon(icon, color: colors.textSecondary, size: 22),
        const SizedBox(width: AppSpacing.smd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: textTheme.titleMedium!.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
                  ),
                  Text(
                    '${value.round()} / ${max.round()}',
                    style: textTheme.bodySmall!.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 6,
                  backgroundColor: barColor.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(barColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
