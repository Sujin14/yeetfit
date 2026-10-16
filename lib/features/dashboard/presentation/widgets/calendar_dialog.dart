import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/month_day_grid.dart';
import 'package:yeetfit/shared/widgets/pill_day_cell.dart';
import 'package:yeetfit/shared/widgets/weekday_header_row.dart';
import '../providers/selected_date_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Picks the dashboard date: any day from a year ago up to today.
class CalendarDialog extends ConsumerStatefulWidget {
  const CalendarDialog({super.key});

  @override
  ConsumerState<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends ConsumerState<CalendarDialog> {
  late final DateTime _today;
  late final DateTime _firstDay;
  late DateTime _visibleMonth;
  late DateTime _selected;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  void initState() {
    super.initState();
    _today = _dateOnly(DateTime.now());
    _firstDay = _today.subtract(const Duration(days: 365));
    _selected = _dateOnly(ref.read(selectedDateProvider));
    _visibleMonth = DateTime(_selected.year, _selected.month);
  }

  bool get _canGoBack =>
      _visibleMonth.isAfter(DateTime(_firstDay.year, _firstDay.month));
  bool get _canGoForward =>
      _visibleMonth.isBefore(DateTime(_today.year, _today.month));

  void _shiftMonth(int delta) => setState(() {
    _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
  });

  void _confirm() {
    ref.read(selectedDateProvider.notifier).select(_selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final dayTextStyle = textTheme.bodySmall!;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.gradientStart, colors.gradientEnd],
          ),
        ),
        child: GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GlassIconButton(
                    icon: Icons.chevron_left,
                    color: _canGoBack ? colors.onBackground : colors.textMuted,
                    tooltip: 'Previous month',
                    onPressed: _canGoBack ? () => _shiftMonth(-1) : null,
                  ),
                  Expanded(
                    child: Text(
                      DateFormat('MMMM yyyy').format(_visibleMonth),
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium!.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
                  ),
                  GlassIconButton(
                    icon: Icons.chevron_right,
                    color: _canGoForward
                        ? colors.onBackground
                        : colors.textMuted,
                    tooltip: 'Next month',
                    onPressed: _canGoForward ? () => _shiftMonth(1) : null,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const WeekdayHeaderRow(),
              const SizedBox(height: 10),
              MonthDayGrid(
                month: _visibleMonth,
                outsideDayBuilder: (day) => Text(
                  '${day.day}',
                  style: dayTextStyle.copyWith(color: colors.textMuted),
                ),
                dayBuilder: (day) {
                  final selectable =
                      !day.isAfter(_today) && !day.isBefore(_firstDay);
                  final isSelected = day == _selected;
                  return PillDayCell(
                    label: '${day.day}',
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [colors.primary, colors.secondary],
                          )
                        : null,
                    fillColor: selectable
                        ? Colors.white.withValues(alpha: 0.08)
                        : null,
                    textColor: isSelected
                        ? colors.onPrimary
                        : selectable
                        ? colors.onBackground
                        : colors.textMuted,
                    showRing: day == _today,
                    onTap: selectable
                        ? () => setState(() => _selected = day)
                        : null,
                  );
                },
              ),
              const SizedBox(height: 20),
              GradientButton(
                label: 'Show ${DateFormat('d MMM').format(_selected)}',
                onPressed: _confirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
