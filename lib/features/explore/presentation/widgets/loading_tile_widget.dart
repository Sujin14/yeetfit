import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class LoadingTileWidget extends StatelessWidget {
  const LoadingTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppTheme.colors['cardBackground'] ?? Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 24.sp,
            color: AppTheme.colors['secondaryIcon'] ?? Colors.grey,
          ),
          SizedBox(width: 16.w),
          Text(
            'Loading...',
            style:
                AppTheme.textStyles['body']?.copyWith(
                  color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                  fontSize: 16.sp,
                ) ??
                TextStyle(fontSize: 16.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
