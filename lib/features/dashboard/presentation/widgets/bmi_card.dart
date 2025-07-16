import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';

class BMICard extends StatelessWidget {
  final double bmi;

  const BMICard({super.key, required this.bmi});

  // Compute BMI category
  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obesity';
  }

  // Compute BMI suggestion
  String _getBMISuggestion(double bmi) {
    if (bmi < 18.5) {
      return 'Consider a balanced diet with more calories and consult a nutritionist.';
    }
    if (bmi < 25) {
      return 'Great job! Maintain a healthy lifestyle with regular exercise and balanced nutrition.';
    }
    if (bmi < 30) {
      return 'Incorporate regular physical activity and a balanced diet to achieve a healthy weight.';
    }
    return 'Consult a healthcare professional for a personalized weight management plan.';
  }

  // Get color based on BMI
  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFFFF6B6B);
    if (bmi < 25) return const Color(0xFF4CAF50);
    if (bmi < 30) return const Color(0xFFFFD700);
    return const Color(0xFFFFB347);
  }

  @override
  Widget build(BuildContext context) {
    final bmiCategory = _getBMICategory(bmi);
    final bmiSuggestion = _getBMISuggestion(bmi);
    final bmiColor = _getBMIColor(bmi);

    return GlassmorphicContainer(
      width: double.infinity,
      height: 160.h,
      borderRadius: 16.r,
      blur: 10,
      alignment: Alignment.center,
      border: 3,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [bmiColor.withOpacity(0.1), bmiColor.withOpacity(0.05)],
      ),
      borderGradient: LinearGradient(
        colors: [bmiColor, bmiColor.withOpacity(0.7)],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bmiColor.withOpacity(0.2),
                border: Border.all(color: bmiColor, width: 2.w),
              ),
              child: Center(
                child: Text(
                  bmi.toStringAsFixed(1),
                  style: AppTheme.textStyles['heading']!.copyWith(
                    fontSize: 24.sp,
                    color: AppTheme.colors['primaryText'],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your BMI',
                    style: AppTheme.textStyles['subtitle']!.copyWith(
                      fontSize: 18.sp,
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Category: $bmiCategory',
                    style: AppTheme.textStyles['body']!.copyWith(
                      fontSize: 16.sp,
                      color: AppTheme.colors['secondaryText'],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Recommendation: $bmiSuggestion',
                    style: AppTheme.textStyles['body']!.copyWith(
                      fontSize: 14.sp,
                      color: AppTheme.colors['secondaryText'],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
