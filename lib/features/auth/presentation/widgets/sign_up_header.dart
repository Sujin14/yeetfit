import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Account',
            style: AppTheme.textStyles['heading']!.copyWith(fontSize: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            'Join YeetFit to begin your fitness journey!',
            style: AppTheme.textStyles['subtitle']!.copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
