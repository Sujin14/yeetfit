import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/month_day_grid.dart';
import 'package:yeetfit/shared/widgets/pill_day_cell.dart';
import 'package:yeetfit/shared/widgets/weekday_header_row.dart';
import '../../domain/entities/daily_progress.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Month of day cells coloured by completion of the selected metric. Tapping
/// a day shows its date and completion.
class ProgressCalendarGrid extends StatelessWidget {
  final DateTime month;
  final List<DailyProgress> days;

  const ProgressCalendarGrid({
    super.key,
    required this.month,
    required this.days,
  });

  static Color _fillFor(AppColors colors, double? rate) {
    if (rate == null) return Colors.white.withValues(alpha: 0.06);
    final percent = (rate * 100).round();
    if (percent <= 25) return colors.progressNone;
    if (percent <= 50) return colors.progress25;
    if (percent <= 75) return colors.progress50;
    if (percent < 100) return colors.progress75;
    return colors.progressFull;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final rateByDate = {for (final day in days) day.date: day.completionRate};

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.smd,
          AppSpacing.md,
          AppSpacing.smd,
          AppSpacing.md,
        ),
        child: Column(
          children: [
            const WeekdayHeaderRow(),
            const SizedBox(height: 10),
            MonthDayGrid(
              month: month,
              dayBuilder: (day) {
                final isFuture = day.isAfter(today);
                final key = DateFormat('yyyy-MM-dd').format(day);
                final rate = isFuture ? null : rateByDate[key];
                final fill = _fillFor(colors, rate);
                final textColor = rate == null
                    ? colors.onBackground
                    : ThemeData.estimateBrightnessForColor(fill) ==
                          Brightness.light
                    ? Colors.black
                    : Colors.white;
                final summary = rate == null
                    ? 'No data'
                    : '${(rate * 100).round()}% complete';

                return Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: '${DateFormat('EEE, d MMM').format(day)} · $summary',
                  child: PillDayCell(
                    label: '${day.day}',
                    fillColor: fill,
                    textColor: textColor,
                    showRing: day == today,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
