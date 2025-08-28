import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class SleepTipsCard extends StatelessWidget {
  const SleepTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: AppTheme.colors['cardBackground']!,
      padding: EdgeInsets.all(isDesktop ? 16.w : 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips to Sleep Better',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: isDesktop ? 16.sp : 18.sp,
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'To improve your sleep quality, exercise daily. Vigorous exercise is best, but even light exercise is better than no activity.',
            style: AppTheme.textStyles['body']!.copyWith(
              fontSize: isDesktop ? 12.sp : 14.sp,
              color: AppTheme.colors['onSurfaceDark']!.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
