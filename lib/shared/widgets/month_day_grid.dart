import 'package:flutter/material.dart';

/// 7-column (Mon–Sun) grid of the days in [month]. Leading and trailing slots
/// are filled by [outsideDayBuilder] when given, otherwise left empty.
class MonthDayGrid extends StatelessWidget {
  final DateTime month;
  final Widget Function(DateTime day) dayBuilder;
  final Widget Function(DateTime day)? outsideDayBuilder;

  const MonthDayGrid({
    super.key,
    required this.month,
    required this.dayBuilder,
    this.outsideDayBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = first.weekday - 1;
    final cellCount = ((leading + daysInMonth + 6) ~/ 7) * 7;

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      mainAxisSpacing: 6,
      children: [
        for (var index = 0; index < cellCount; index++)
          // Day 0 and negatives roll back into the previous month.
          Center(
            child: _cell(
              DateTime(month.year, month.month, index - leading + 1),
            ),
          ),
      ],
    );
  }

  Widget _cell(DateTime day) {
    if (day.month == month.month) return dayBuilder(day);
    return outsideDayBuilder?.call(day) ?? const SizedBox.shrink();
  }
}
