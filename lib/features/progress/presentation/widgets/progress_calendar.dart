import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class ProgressCalendar extends StatelessWidget {
  final Map<DateTime, int> dataset;

  const ProgressCalendar({
    super.key,
    required this.dataset,
  });

  @override
  Widget build(BuildContext context) {
    if (dataset.isNotEmpty) {
      final sample = dataset.entries
          .take(8)
          .map((e) => '${e.key.toIso8601String().substring(0, 10)}:${e.value}')
          .join(', ');
    }

    if (dataset.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['secondaryText'],
            fontSize: 16.sp,
          ),
        ),
      );
    }

    return HeatMapCalendar(
      datasets: dataset,
      colorMode: ColorMode.opacity,
      colorsets: {1: AppTheme.colors['fullProgress']!},
      showColorTip: true,
      monthFontSize: 16,
      weekFontSize: 12,
      textColor: AppTheme.colors['primaryText'],
      defaultColor: AppTheme.colors['gray']!.withOpacity(0.2),
      size: 32,
      margin: const EdgeInsets.all(4),
      onClick: (date) {},
    );
  }
}