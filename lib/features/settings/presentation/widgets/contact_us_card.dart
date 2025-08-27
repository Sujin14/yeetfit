import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class ContactUsCard extends StatelessWidget {
  final VoidCallback onTap;

  const ContactUsCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Us',
                        style: AppTheme.textStyles['subtitle']!.copyWith(
                          fontSize: 18.sp,
                          color: AppTheme.colors['primaryText'],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Get in touch with our support team',
                        style: AppTheme.textStyles['body']!.copyWith(
                          fontSize: 14.sp,
                          color: AppTheme.colors['secondaryText'],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.colors['primaryText'],
                  size: 16.sp,
                ),
              ],
            ),
          ),
          Divider(color: AppTheme.colors['borderGradientStart']),
        ],
      ),
    );
  }
}