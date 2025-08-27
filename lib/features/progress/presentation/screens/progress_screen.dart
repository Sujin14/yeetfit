import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
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
          padding: EdgeInsets.all(FixedSizes.box16(context)),
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
              SizedBox(height: FixedSizes.box16(context)),
              progressAsync.when(
                data: (progressList) {
                  final dataset = <DateTime, int>{};
                  for (final DailyProgress p in progressList) {
                    DateTime? d;
                    try {
                      d = DateTime.parse(p.date);
                    } catch (_) {
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

                  if (dataset.isEmpty) {
                    return const Center(child: Text("No data available"));
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
                          fontSize: FixedSizes.font16(context),
                        ),
                      ),
                      SizedBox(height: FixedSizes.box8(context)),
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
                            fontSize: FixedSizes.font14(context),
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
