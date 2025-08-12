import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
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
              'About Our App',
              style: AppTheme.textStyles['subtitle']!.copyWith(
                fontSize: 24.sp,
                color: AppTheme.colors['primaryText'],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Our app is designed to help you achieve your health and fitness goals through personalized tracking and insights. Track your weight, water intake, steps, and sleep, and customize your diet preferences to suit your lifestyle.',
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
              '- Personalized goal setting\n'
              '- Diet and workout tracking\n'
              '- Real-time progress monitoring\n'
              '- User-friendly interface',
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