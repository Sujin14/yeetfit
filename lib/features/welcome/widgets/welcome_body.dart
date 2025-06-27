import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/user_theme.dart';
import 'welcome_button.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          Lottie.asset(
            'assets/animations/running.json',
            height: 300.h,
            repeat: true,
          ),

          SizedBox(height: 32.h),

          Text(
            "Welcome to YeetFit",
            style: AppTextStyles.heading.copyWith(
              color: UserTheme.darkText,
              fontSize: 30.sp,
            ),
          ),

          SizedBox(height: 12.h),

          Text(
            "Track your health. Follow your goals.",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: UserTheme.darkText,
              fontSize: 20.sp,
            ),
          ),

          const Spacer(),

          WelcomeButton(
            label: "Login",
            color: Colors.green,
            onPressed: () => context.push('/login'),
          ),

          SizedBox(height: 12.h),

          WelcomeButton(
            label: "Login as Admin",
            color: Colors.green,
            onPressed: () => context.push('/admin-login'),
          ),
        ],
      ),
    );
  }
}
