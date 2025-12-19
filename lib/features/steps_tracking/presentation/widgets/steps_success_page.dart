import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../providers/steps_provider.dart';
import '../../../../shared/theme/theme.dart';

// Success page for steps goal achievement.
class StepsSuccessPage extends ConsumerWidget {
  final String goal;

  const StepsSuccessPage({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(stepsSuccessMessageProvider(goal));
    return Scaffold(
      backgroundColor: AppTheme.colors['background'],
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
            style: GoogleFonts.roboto(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['teal'],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              message,
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                color: AppTheme.colors['primaryText'],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30.h),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['navBarActive'],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Done',
              style: GoogleFonts.roboto(fontSize: 16.sp, color: AppTheme.colors['white']),
            ),
          ),
        ],
      ),
    );
  }
}