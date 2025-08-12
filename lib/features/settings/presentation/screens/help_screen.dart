import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help',
          style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
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
              'Q: How do I set my goals?\n'
              'A: Navigate to Settings > Account > Goal Settings to set your weight, water, steps, and sleep goals.\n\n'
              'Q: How do I contact support?\n'
              'A: Email us at support@ourapp.com for assistance.',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}