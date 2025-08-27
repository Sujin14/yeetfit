import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class HelpBody extends StatelessWidget {
  const HelpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Help & Support',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: 24.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Need assistance? Here are some common questions and answers to help you get started.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'FAQs',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: 18.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Q: How do I update my profile?\n'
            'A: Go to Settings > Account > Basic Information to update your profile details.\n\n'
            'Q: How do I set my fitness goals?\n'
            'A: Navigate to Settings > Account > Goal Settings to set your fitness goals.\n\n'
            'Q: How do I contact support?\n'
            'A: Email us at support@oyeetfit.com for assistance.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ],
      ),
    );
  }
}