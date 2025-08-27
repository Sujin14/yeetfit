import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yeetfit/shared/theme/theme.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40.w,
        height: 6.h,
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppTheme.colors['onSurface']?.withOpacity(0.5) ?? Colors.grey,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}
