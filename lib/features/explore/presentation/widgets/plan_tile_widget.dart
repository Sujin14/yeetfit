import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class PlanTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const PlanTileWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppTheme.colors['cardBackground'] ?? Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: (AppTheme.colors['shadow'] ?? Colors.grey).withOpacity(
                0.1,
              ),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: AppTheme.colors['primaryIcon'] ?? Colors.blue,
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style:
                  AppTheme.textStyles['body']?.copyWith(
                    color: AppTheme.colors['primaryText'] ?? Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ) ??
                  TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
