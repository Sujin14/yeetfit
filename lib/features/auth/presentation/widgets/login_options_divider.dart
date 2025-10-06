import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class LoginOptionsDivider extends StatelessWidget {
  const LoginOptionsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppTheme.colors['secondaryText']!.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "or continue with",
            style: AppTheme.textStyles['body']!.copyWith(
              fontSize: 14.sp,
              color: AppTheme.colors['secondaryText']!.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppTheme.colors['secondaryText']!.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
