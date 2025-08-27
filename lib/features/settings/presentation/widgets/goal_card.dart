import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final String selectedGoal;
  final ValueChanged<String?> onGoalSelected;

  const GoalCard({
    super.key,
    required this.title,
    required this.selectedGoal,
    required this.onGoalSelected,
  });

  @override
  Widget build(BuildContext context) {
    final goalTypes = ['weight loss', 'weight gain', 'muscle building'];

    return GlassmorphicContainer(
      width: double.infinity,
      height: 120.h,
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
          AppTheme.colors['gradientTextStart']!,
          AppTheme.colors['gradientTextEnd']!,
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTheme.textStyles['subtitle']!.copyWith(
                fontSize: 18.sp,
                color: AppTheme.colors['primaryText'],
              ),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              value: goalTypes.contains(selectedGoal)
                  ? selectedGoal
                  : goalTypes[0],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: AppTheme.colors['borderGradientStart']!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: AppTheme.colors['borderGradientStart']!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: AppTheme.colors['gradientTextStart']!,
                  ),
                ),
              ),
              items: goalTypes
                  .map(
                    (goal) => DropdownMenuItem(
                      value: goal,
                      child: Text(
                        goal,
                        style: AppTheme.textStyles['body']!.copyWith(
                          fontSize: 14.sp,
                          color: AppTheme.colors['primaryText'],
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onGoalSelected,
              dropdownColor: AppTheme.colors['lightBackground'],
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppTheme.colors['primaryText'],
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
