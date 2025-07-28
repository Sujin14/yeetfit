import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/dashboard_provider.dart';

class CalendarDialog extends ConsumerWidget {
  final String userId;

  const CalendarDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    print(
      'CalendarDialog: Building for userId=$userId, selectedDate=$selectedDate',
    );

    return Dialog(
      backgroundColor: Colors.white,
      child: GlassmorphicContainer(
        width: 350.w,
        height: 485.h,
        borderRadius: 16.r,
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
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Select Date',
                style: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colors['primaryText'],
                ),
              ),
            ),

            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
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
                    defaultTextStyle: GoogleFonts.roboto(
                      fontSize: 14.sp,
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
                    titleTextStyle: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: AppTheme.colors['primaryText'],
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppTheme.colors['primaryText'],
                      size: 24.sp,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppTheme.colors['primaryText'],
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
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
