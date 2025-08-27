import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class ContactUsBody extends StatelessWidget {
  const ContactUsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Contact Us',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: 24.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'We’re here to help! Reach out to our support team for any questions or issues.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Contact Information',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: 18.sp,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Email: support@oyeetfit.com\n'
            'Phone: +1-800-555-1234\n'
            'Address: 123 Fitness Lane, Health City, HC 12345',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ],
      ),
    );
  }
}