import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/models/plan_model.dart';

class PlanListItem extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;

  const PlanListItem({super.key, required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 100.h,
      borderRadius: 20.r,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.colors['navigationAccent']!,
          AppTheme.colors['navigationAccent']!.withOpacity(0.8),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['borderGradientStart']!,
          AppTheme.colors['borderGradientEnd']!,
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: Text(
          plan.title,
          style: AppTheme.textStyles['title']!.copyWith(
            color: AppTheme.colors['primaryText'],
            fontSize: 18.sp,
          ),
        ),
        subtitle: Text(
          plan.type == 'diet'
              ? '${plan.details['meals']?.length ?? 0} meals'
              : '${plan.details['exercises']?.length ?? 0} exercises',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['secondaryText'],
            fontSize: 14.sp,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: AppTheme.colors['primaryText'],
        ),
        onTap: onTap,
      ),
    );
  }
}
