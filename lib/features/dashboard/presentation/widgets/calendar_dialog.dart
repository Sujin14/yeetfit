import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/selected_date_provider.dart';

class CalendarDialog extends ConsumerWidget {
  final String userId;
  const CalendarDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final colors = Theme.of(context).extension<AppColors>()!;

    return Dialog(
      backgroundColor: Colors.white,
      child: GlassmorphicContainer(
        width: 350.w,
        height: 530.h,
        borderRadius: 16.r,
        blur: 10,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            colors.navAccent.withOpacity(0.1),
            colors.navAccent.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [colors.primary, colors.secondary],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(
                'Select Date',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontSize: 20.sp),
              ),
            ),
            Flexible(
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
                  defaultTextStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
                  selectedDecoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: colors.onSurface.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium!,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: colors.onSurface,
                    size: 24.sp,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: colors.onSurface,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
