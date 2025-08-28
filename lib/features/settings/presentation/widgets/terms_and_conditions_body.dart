import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class TermsAndConditionsBody extends StatelessWidget {
  const TermsAndConditionsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Terms & Conditions',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: 24.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'By using our app, you agree to the following terms and conditions.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'User Responsibilities',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: 18.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Service Usage',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: 18.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Our services are provided "as is" without warranties of any kind. We reserve the right to modify or discontinue services at any time.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ],
      ),
    );
  }
}