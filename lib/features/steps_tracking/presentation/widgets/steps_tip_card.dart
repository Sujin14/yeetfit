import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsTipCard extends StatelessWidget {
  const StepsTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return GlassmorphicContainer(
      color: AppTheme.colors['cardBackground']!,
      padding: EdgeInsets.all(isDesktop ? 16.w : 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today’s Tip',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: isDesktop ? 16.sp : 18.sp,
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          SizedBox(height: 8.h),
          Divider(color: AppTheme.colors['borderGradientStart']),
          SizedBox(height: 8.h),
          Text(
            'Weighted vests can make your walks more effective. Use one that’s only 5–10% of your body weight for safety and comfort.',
            style: AppTheme.textStyles['body']!.copyWith(
              fontSize: isDesktop ? 14.sp : 16.sp,
              color: AppTheme.colors['onSurfaceDark']!.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}