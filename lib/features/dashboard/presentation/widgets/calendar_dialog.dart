// features/dashboard/presentation/widgets/calendar_dialog.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/dashboard_provider.dart';
import 'package:glassmorphism/glassmorphism.dart';

class CalendarDialog extends ConsumerWidget {
  final String userId;

  const CalendarDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Dialog(
      backgroundColor: AppTheme.colors['white'],
      child: GlassmorphicContainer(
        width: FixedSizes.box100(context) * 3.5, // approx 350
        height: FixedSizes.box100(context) * 5.2, // approx 520
        borderRadius: FixedSizes.borderRadius(context) / 1.5,
        blur: 10,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            AppTheme.colors['navigationAccent']!.withOpacity(0.1),
            AppTheme.colors['navigationAccent']!.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            AppTheme.colors['gradientTextStart']!,
            AppTheme.colors['gradientTextEnd']!,
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(FixedSizes.box16(context)),
              child: Text(
                'Select Date',
                style: AppTheme.textStyles['title']!.copyWith(
                  fontSize: FixedSizes.fontTitle(context),
                  color: AppTheme.colors['primaryText'],
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: FixedSizes.box8(context)),
                child: TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now(),
                  focusedDay: selectedDate,
                  selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                  onDaySelected: (selectedDay, focusedDay) {
                    ref.read(selectedDateProvider.notifier).state = selectedDay;
                    Navigator.pop(context);
                  },
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: AppTheme.textStyles['body']!.copyWith(
                      fontSize: FixedSizes.font14(context),
                      color: AppTheme.colors['primaryText'],
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppTheme.colors['primaryAccent'],
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppTheme.colors['secondaryText']!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: AppTheme.textStyles['subtitle']!.copyWith(
                      color: AppTheme.colors['primaryText'],
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppTheme.colors['primaryText'],
                      size: FixedSizes.font16(context) * 1.5,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppTheme.colors['primaryText'],
                      size: FixedSizes.font16(context) * 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: FixedSizes.box8(context)),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTheme.textStyles['body']!.copyWith(
                    fontSize: FixedSizes.font16(context),
                    color: AppTheme.colors['primaryText'],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
