import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import 'bmi_front_painter.dart';
import 'welcome_text.dart';
import 'bmi_shimmer_card.dart';

class BMIFrontCard extends StatelessWidget {
  final AsyncValue<Map<String, dynamic>?> userData;

  const BMIFrontCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CustomPaint(
          painter: BmiFrontPainter(colors),
          child: Container(
            width: double.infinity,
            height: 220.h,
            padding: EdgeInsets.all(16.w),
            alignment: Alignment.center,
            child: userData.when(
              data: (u) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WelcomeText(name: u?['name'] ?? 'User'),
                  SizedBox(height: 16.h),
                  Text(
                    'Tap to check your BMI',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16.sp,
                          color: colors.onSurface.withOpacity(0.85),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 8.h),
                  Icon(
                    Icons.touch_app_rounded,
                    color: colors.onSurface.withOpacity(0.8),
                    size: 22.sp,
                  ),
                ],
              ),
              loading: () => const BMIShimmerCard(),
              error: (e, _) => Text('Error: $e'),
            ),
          ),
        ),
      ),
    );
  }
}
