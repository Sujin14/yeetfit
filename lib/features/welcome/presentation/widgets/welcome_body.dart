import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/welcome_button.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/welcome1.png',
            width: double.infinity,
            height: 500.h,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                GradientText(
                  text: 'Welcome to YeetFit!',
                  style: AppTheme.textStyles['heading']!.copyWith(
                    fontSize: 36.sp,
                  ),
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.yellow, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Start your fitness journey today',
                  style: AppTheme.textStyles['subtitle']!.copyWith(
                    fontSize: 20.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                WelcomeButton(
                  label: 'Log In',
                  onPressed: () => context.push('/login'),
                  color: Colors.white,
                ),
                SizedBox(height: 16.h),
                WelcomeButton(
                  label: 'Sign Up',
                  onPressed: () => context.push('/signup'),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
