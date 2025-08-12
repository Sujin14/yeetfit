import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';

class TermsAndConditionsCard extends StatelessWidget {
  final VoidCallback onTap;

  const TermsAndConditionsCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 100.h,
        borderRadius: 16.r,
        blur: 10,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          colors: [
            AppTheme.colors['navigationAccent']!.withOpacity(0.1),
            AppTheme.colors['navigationAccent']!.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [AppTheme.colors['gradientTextStart']!, AppTheme.colors['gradientTextEnd']!],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Terms & Conditions',
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: 18.sp,
                  color: AppTheme.colors['primaryText'],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Review our terms of use',
                style: AppTheme.textStyles['body']!.copyWith(
                  fontSize: 14.sp,
                  color: AppTheme.colors['secondaryText'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}