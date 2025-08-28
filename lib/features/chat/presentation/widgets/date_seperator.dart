import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class DateSeparator extends StatelessWidget {
  final String dateText;

  const DateSeparator({super.key, required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppTheme.colors['secondaryAccent']!.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            dateText,
            style: AppTheme.textStyles['bodySmall']?.copyWith(
              color: AppTheme.colors['secondaryText'],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
