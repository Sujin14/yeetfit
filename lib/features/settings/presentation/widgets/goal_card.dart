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
    const goals = ['weight loss', 'muscle gain', 'maintenance'];

    return GlassmorphicContainer(
      width: double.infinity,
      height: 100.h,
      borderRadius: 16.r,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          AppTheme.colors['cardBackground']!.withOpacity(0.1),
          AppTheme.colors['cardBackground']!.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['borderGradientStart']!,
          AppTheme.colors['borderGradientEnd']!,
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTheme.textStyles['subheading']!.copyWith(
                      fontSize: 18.sp,
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DropdownButton<String>(
                    value: selectedGoal,
                    items: goals
                        .map((goal) => DropdownMenuItem(
                              value: goal,
                              child: Text(
                                goal.replaceFirst(
                                    goal[0], goal[0].toUpperCase()),
                                style: AppTheme.textStyles['body']!.copyWith(
                                  color: AppTheme.colors['primaryText'],
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: onGoalSelected,
                    style: AppTheme.textStyles['body']!.copyWith(
                      color: AppTheme.colors['primaryText'],
                    ),
                    underline: const SizedBox(),
                    dropdownColor: AppTheme.colors['cardBackground'],
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