import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/models/plan_model.dart';
import 'diet_details_widget.dart';
import 'workout_details_widget.dart';

class PlanDetailsDisplay extends StatelessWidget {
  final PlanModel plan;
  final String? category;

  const PlanDetailsDisplay({super.key, required this.plan, this.category});

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'PlanDetailsDisplay: plan.type=${plan.type}, category=$category',
    );
    final isDiet = plan.type == 'diet' || category == 'diet';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (plan.details['description'] != null &&
            plan.details['description'].isNotEmpty) ...[
          Text(
            'Description: ${plan.details['description']}',
            style:
                AppTheme.textStyles['body']?.copyWith(
                  color: AppTheme.colors['primaryText'] ?? Colors.black,
                  fontSize: 16.sp,
                ) ??
                TextStyle(fontSize: 16.sp, color: Colors.black),
          ),
          SizedBox(height: 16.h),
        ],
        Expanded(
          child: isDiet
              ? DietDetailsWidget(meals: plan.details['meals'] ?? [])
              : WorkoutDetailsWidget(
                  exercises: plan.details['exercises'] ?? [],
                ),
        ),
      ],
    );
  }
}
