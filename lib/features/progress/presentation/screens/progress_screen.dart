import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/progress_calendar.dart';
import '../widgets/progress_header.dart';
import '../providers/progress_provider.dart';


class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = DateTime.now();
    final progressAsync = ref.watch(monthlyProgressProvider(month));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProgressHeader(
                onMetricChanged: (value) {
                  final metric = value == 'All Metrics' ? null : value?.toLowerCase();
                  ref.read(selectedMetricProvider.notifier).state = metric;
                  Future.delayed(Duration.zero, () {
                    ref.read(monthlyProgressProvider(month).notifier).refresh();
                  });
                },
              ),
              SizedBox(height: 16.h),
              progressAsync.when(
                data: (progress) {
                  return ProgressCalendar(progress: progress);
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Error: $error', style: TextStyle(fontSize: 16.sp)),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(monthlyProgressProvider(month).notifier).refresh();
                          },
                          child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}