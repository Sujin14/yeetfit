import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/progress_provider.dart';

class ProgressHeader extends ConsumerWidget {
  final ValueChanged<String?> onMetricChanged;

  const ProgressHeader({super.key, required this.onMetricChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final selected = ref.watch(selectedMetricProvider) ?? 'All Metrics';

    return Container(
      padding: EdgeInsets.all(isDesktop ? 20.w : 16.w),
      decoration: BoxDecoration(
        color: AppTheme.colors['cardBackground'],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.colors['borderGradientStart']!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Progress Heatmap',
            style: AppTheme.textStyles['title']!.copyWith(
              color: AppTheme.colors['primaryText'],
              fontSize: 20.sp,
            ),
          ),
          DropdownButton<String>(
            value: selected,
            dropdownColor: AppTheme.colors['cardBackground']!.withOpacity(0.9),
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
              fontSize: isDesktop ? 16.sp : 14.sp,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: AppTheme.colors['primaryIcon'],
            ),
            underline: const SizedBox(),
            onChanged: (value) {
              final v = value == 'All Metrics' ? null : value;
              ref.read(selectedMetricProvider.notifier).state = v;
              onMetricChanged(value);
            },
            items: [
              DropdownMenuItem(
                value: 'All Metrics',
                child: Text(
                  'All Metrics',
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['primaryText'],
                    fontSize: isDesktop ? 16.sp : 14.sp,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'food',
                child: Text(
                  'Meal Tracking',
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['primaryText'],
                    fontSize: isDesktop ? 16.sp : 14.sp,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'sleep',
                child: Text(
                  'Sleep',
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['primaryText'],
                    fontSize: isDesktop ? 16.sp : 14.sp,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'steps',
                child: Text(
                  'Steps',
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['primaryText'],
                    fontSize: isDesktop ? 16.sp : 14.sp,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'water',
                child: Text(
                  'Water',
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['primaryText'],
                    fontSize: isDesktop ? 16.sp : 14.sp,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'weight',
                child: Text(
                  'Weight',
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['primaryText'],
                    fontSize: isDesktop ? 16.sp : 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
