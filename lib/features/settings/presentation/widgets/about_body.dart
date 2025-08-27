import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class AboutBody extends StatelessWidget {
  const AboutBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'About Our App',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: 24.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Our app is designed to help you achieve your health and fitness goals through personalized tracking and insights. Set your fitness goals, customize your diet preferences, and track your progress with a user-friendly interface.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Features',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: 18.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '- Personalized fitness goal setting\n'
            '- Diet preference and allergy customization\n'
            '- Real-time progress monitoring\n'
            '- User-friendly interface',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ],
      ),
    );
  }
}