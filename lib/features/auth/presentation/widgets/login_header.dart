import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kIsWeb ? 40.w : 24.w,
        vertical: kIsWeb ? 20.h : 16.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  'Welcome Back',
                  style: AppTheme.textStyles['heading']!.copyWith(
                    fontSize: (kIsWeb ? 26.sp : 24.sp).clamp(20.0, 26.0),
                    color: AppTheme.colors['primaryText'],
                  ),
                  softWrap: false,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Login to your account',
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: (kIsWeb ? 16.sp : 14.sp).clamp(12.0, 16.0),
                  color: AppTheme.colors['secondaryText'],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
