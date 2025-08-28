import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class PrivacyPolicyBody extends StatelessWidget {
  const PrivacyPolicyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Privacy Policy',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: 24.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Your privacy is important to us. This Privacy Policy outlines how we collect, use, and protect your personal information.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Data Collection',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: 18.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'We collect information such as your name, email, fitness goals, and dietary preferences to provide personalized services. All data is stored securely and is not shared with third parties without your consent.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Data Usage',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: 18.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your data is used to customize your experience, provide insights, and improve our services. We may use anonymized data for analytics purposes.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ],
      ),
    );
  }
}