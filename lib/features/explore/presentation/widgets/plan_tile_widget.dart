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
    return Card(
      color: AppTheme.colors['cardBackground'],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 4, // subtle shadow
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        leading: Icon(icon, size: 24.sp, color: AppTheme.colors['primaryIcon']),
        title: Text(
          title,
          style:
              AppTheme.textStyles['body']?.copyWith(
                color: AppTheme.colors['primaryText'],
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ) ??
              TextStyle(
                fontSize: 18.sp,
                color: AppTheme.colors['black'],
                fontWeight: FontWeight.w500,
              ),
        ),
        onTap: onTap,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: AppTheme.colors['primaryIcon'],
        ),
      ),
    );
  }
}
