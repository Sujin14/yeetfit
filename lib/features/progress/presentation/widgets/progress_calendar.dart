import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../domain/usecases/daily_progress.dart';
import '../providers/progress_provider.dart';

class ProgressCalendar extends ConsumerWidget {
  final List<DailyProgress> progress;

  const ProgressCalendar({super.key, required this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return GlassmorphicContainer(
      color: AppTheme.colors['teal']!,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 30 Days',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: 16.sp,
              color: AppTheme.colors['white'],
            ),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.h,
              childAspectRatio: 1,
            ),
            itemCount: progress.length,
            itemBuilder: (context, index) {
              final progressData = progress[index];
              final date = progressData.date;
              final color = ref.watch(dailyProgressColorProvider('$userId|$date'));
              return Tooltip(
                message: 'Day ${index + 1}: ${(progressData.completionRate * 100).toStringAsFixed(0)}% completed',
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: AppTheme.colors['white']!.withOpacity(0.3)),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildLegendItem('Low', AppTheme.colors['halfProgress']!),
              SizedBox(width: 8.w),
              _buildLegendItem('Medium', AppTheme.colors['threeQuarterProgress']!),
              SizedBox(width: 8.w),
              _buildLegendItem('High', AppTheme.colors['fullProgress']!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTheme.textStyles['caption']!.copyWith(
            fontSize: 12.sp,
            color: AppTheme.colors['white']!.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}