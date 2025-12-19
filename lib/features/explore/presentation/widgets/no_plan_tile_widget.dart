import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class NoPlanTileWidget extends StatelessWidget {
  final String message;

  const NoPlanTileWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppTheme.colors['cardBackground'],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 24.sp,
            color: AppTheme.colors['secondaryIcon'],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              message,
              style:
                  AppTheme.textStyles['body']?.copyWith(
                    color: AppTheme.colors['secondaryText'],
                    fontSize: 16.sp,
                  ) ??
                  TextStyle(fontSize: 16.sp, color: AppTheme.colors['gray']),
            ),
          ),
        ],
      ),
    );
  }
}
