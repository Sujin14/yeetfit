import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/progress_provider.dart';
import '../widgets/progress_calendar.dart';
import '../widgets/progress_header.dart';

class ProgressScreenBody extends ConsumerWidget {
  const ProgressScreenBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);
    final progressAsync = ref.watch(monthlyProgressProvider(firstOfMonth));
    final dataset = ref.watch(progressDatasetProvider(firstOfMonth));

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressHeader(
              onMetricChanged: (_) {
                ref
                    .read(monthlyProgressProvider(firstOfMonth).notifier)
                    .refresh();
              },
            ),
            SizedBox(height: 16.h),
            progressAsync.when(
              data: (_) => ProgressCalendar(dataset: dataset),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error: $error',
                      style: AppTheme.textStyles['body']!.copyWith(
                        color: AppTheme.colors['error'],
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(
                              monthlyProgressProvider(firstOfMonth).notifier,
                            )
                            .refresh();
                      },
                      child: Text(
                        'Retry',
                        style: AppTheme.textStyles['body']!.copyWith(
                          color: AppTheme.colors['primaryText'],
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
