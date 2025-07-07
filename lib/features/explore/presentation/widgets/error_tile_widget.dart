import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class ErrorTileWidget extends StatelessWidget {
  final String message;

  const ErrorTileWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: (AppTheme.colors['error'] ?? Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 24.sp,
            color: AppTheme.colors['error'] ?? Colors.red,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              message,
              style:
                  AppTheme.textStyles['body']?.copyWith(
                    color: AppTheme.colors['error'] ?? Colors.red,
                    fontSize: 16.sp,
                  ) ??
                  TextStyle(fontSize: 16.sp, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
