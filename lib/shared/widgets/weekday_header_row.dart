import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Mon–Sun labels aligned with a 7-column day grid.
class WeekdayHeaderRow extends StatelessWidget {
  const WeekdayHeaderRow({super.key});

  static const List<String> _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final style = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(color: colors.textMuted);
    return Row(
      children: [
        for (final day in _days)
          Expanded(
            child: Text(day, textAlign: TextAlign.center, style: style),
          ),
      ],
    );
  }
}
