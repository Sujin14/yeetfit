import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../../shared/theme/theme.dart';

class FoodPreferencesCard extends StatelessWidget {
  final VoidCallback onTap;

  const FoodPreferencesCard({super.key, required this.onTap});

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
          colors: [
            AppTheme.colors['primaryAccent']!,
            AppTheme.colors['gradientTextEnd']!,
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Food Preferences',
                    style: AppTheme.textStyles['subtitle']!.copyWith(
                      fontSize: 18.sp,
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Diet Preferences, Allergies, Cuisine',
                    style: AppTheme.textStyles['body']!.copyWith(
                      fontSize: 14.sp,
                      color: AppTheme.colors['secondaryText'],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
