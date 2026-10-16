import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// One labelled value in the start → current → goal row.
class WeightMilestone extends StatelessWidget {
  final String label;
  final double? weight;
  final Color valueColor;
  final CrossAxisAlignment alignment;

  const WeightMilestone({
    super.key,
    required this.label,
    required this.weight,
    required this.valueColor,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: textTheme.bodySmall!.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          weight == null ? '--' : '${weight!.toStringAsFixed(1)} kg',
          style: textTheme.titleMedium!.copyWith(color: valueColor),
        ),
      ],
    );
  }
}
