import 'package:flutter/foundation.dart' show kIsWeb;
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
          child: Divider(color: AppTheme.colors['secondaryText']),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 16.w : 12.w),
          child: Text(
            "or continue with",
            style: AppTheme.textStyles['body']!.copyWith(
              fontSize: (kIsWeb ? 14.sp : 12.sp).clamp(10.0, 14.0),
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ),
        Expanded(
          child: Divider(color: AppTheme.colors['secondaryText']),
        ),
      ],
    );
  }
}