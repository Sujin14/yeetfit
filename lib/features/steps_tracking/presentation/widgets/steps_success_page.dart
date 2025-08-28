import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/steps_provider.dart';
import '../../../../shared/theme/theme.dart';
import 'package:lottie/lottie.dart';

class StepsSuccessPage extends ConsumerWidget {
  final String goal;

  const StepsSuccessPage({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(stepsSuccessMessageProvider(goal));
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return Scaffold(
      backgroundColor: AppTheme.colors['cardBackground'],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/success.json',
            width: 300.w,
            height: 300.h,
            fit: BoxFit.contain,
            repeat: false,
          ),
          Text(
            'Congratulations! 🎉',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: isDesktop ? 24.sp : 28.sp,
              color: AppTheme.colors['primaryButton'],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              message,
              style: AppTheme.textStyles['body']!.copyWith(
                fontSize: isDesktop ? 16.sp : 18.sp,
                color: AppTheme.colors['onSurfaceDark'],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30.h),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['primaryButton'],
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Done',
              style: AppTheme.textStyles['body']!.copyWith(
                fontSize: isDesktop ? 14.sp : 16.sp,
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
