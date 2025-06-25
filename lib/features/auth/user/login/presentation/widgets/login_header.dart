import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../shared/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: AppTextStyles.heading.copyWith(fontSize: 26.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                'Login to your account',
                style: AppTextStyles.subtitle.copyWith(fontSize: 16.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
