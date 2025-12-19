import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

// Reusable row of page indicators for onboarding.
class OnboardingIndicators extends StatelessWidget {
  final int currentPage;

  const OnboardingIndicators({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: kIsWeb ? 6.w : 4.w),
          height: kIsWeb ? 10.h : 8.h,
          width: isActive ? (kIsWeb ? 24.w : 20.w) : (kIsWeb ? 10.w : 8.w),
          decoration: BoxDecoration(
            color: AppTheme.colors['orangeAccent'],
            borderRadius: BorderRadius.circular(20.r),
          ),
        );
      }),
    );
  }
}