import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: kIsWeb ? 400.h : 300.h,
          fit: BoxFit.contain,
        ),
        SizedBox(height: kIsWeb ? 40.h : 20.h),
        Text(
          title,
          style: AppTheme.textStyles['heading']!.copyWith(
            color: AppTheme.colors['onSurface'],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: kIsWeb ? 20.h : 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 40.w : 20.w),
          child: Text(
            description,
            style: AppTheme.textStyles['bodyMedium']!.copyWith(
              color: AppTheme.colors['onSurface']!.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}