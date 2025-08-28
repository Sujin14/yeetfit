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
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: 24.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Find answers to common questions or contact our support team.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'FAQs',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: 18.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Q: How do I update my profile information?\n'
            'A: Go to Settings > Account > Basic Information to update your details.\n\n'
            'Q: How can I change my fitness goal?\n'
            'A: Navigate to Settings > Account > Goal Settings to select a new goal.\n\n'
            'Q: How do I contact support?\n'
            'A: Visit the Contact Us section in Settings for support contact details.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ],
      ),
    );
  }
}