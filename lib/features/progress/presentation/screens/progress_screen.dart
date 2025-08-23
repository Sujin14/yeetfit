import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/progress_provider.dart';
import '../widgets/progress_calendar.dart';
import '../widgets/progress_header.dart';
import '../../domain/usecases/daily_progress.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);

    final progressAsync = ref.watch(monthlyProgressProvider(firstOfMonth));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProgressHeader(
                onMetricChanged: (_) {
                  debugPrint(
                    '[UI] ProgressHeader changed metric, refreshing provider for $firstOfMonth',
                  );
                  ref
                      .read(monthlyProgressProvider(firstOfMonth).notifier)
                      .refresh();
                },
              ),
              SizedBox(height: 16.h),
              progressAsync.when(
                data: (progressList) {
                  // Convert List<DailyProgress> -> Map<DateTime, int>
                  final dataset = <DateTime, int>{};
                  for (final DailyProgress p in progressList) {
                    DateTime? d;
                    try {
                      d = DateTime.parse(p.date);
                    } catch (e) {
                      debugPrint('[UI] Skipping invalid date ${p.date}: $e');
                      continue;
                    }

                    final double safe =
                        (p.completionRate.isNaN ? 0.0 : p.completionRate).clamp(
                          0.0,
                          1.0,
                        );
                    final int score = (safe * 10).round();

                    dataset[d] = score;
                  }

                  // debug: show dataset summary
                  debugPrint('[UI] dataset size=${dataset.length}');
                  if (dataset.isNotEmpty) {
                    final sample = dataset.entries
                        .take(5)
                        .map(
                          (e) =>
                              '${e.key.toIso8601String().substring(0, 10)}:${e.value}',
                        )
                        .join(', ');
                    debugPrint('[UI] dataset sample: $sample');
                  } else {
                    debugPrint(
                      '[UI] dataset is empty (no progress for this month)',
                    );
                  }

                  return ProgressCalendar(dataset: dataset);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Error: $error',
                        style: AppTheme.textStyles['body']!.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ElevatedButton(
                        onPressed: () {
                          debugPrint(
                            '[UI] Retry pressed - refreshing provider',
                          );
                          ref
                              .read(
                                monthlyProgressProvider(firstOfMonth).notifier,
                              )
                              .refresh();
                        },
                        child: Text(
                          'Retry',
                          style: AppTheme.textStyles['body']!.copyWith(
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
      ),
    );
  }
}
