import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
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
              'Terms & Conditions',
              style: AppTheme.textStyles['subtitle']!.copyWith(
                fontSize: 24.sp,
                color: AppTheme.colors['primaryText'],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'By using our app, you agree to the following terms and conditions:',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['primaryText'],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '1. Usage\n'
              'You agree to use the app for personal, non-commercial purposes only.\n\n'
              '2. Data Privacy\n'
              'We collect and store your personal information in accordance with our Privacy Policy.\n\n'
              '3. Account Responsibility\n'
              'You are responsible for maintaining the confidentiality of your account credentials.\n\n'
              '4. Termination\n'
              'We reserve the right to terminate your access to the app for violating these terms.',
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