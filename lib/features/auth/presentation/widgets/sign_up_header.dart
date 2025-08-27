import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 40.w : 24.w, vertical: kIsWeb ? 20.h : 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              'Create Account',
              style: AppTheme.textStyles['heading']!.copyWith(
                fontSize: (kIsWeb ? 28.sp : 26.sp).clamp(22.0, 28.0),
                color: AppTheme.colors['primaryText'],
              ),
              softWrap: false,
            ),
          ),
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              'Join YeetFit to begin your fitness journey!',
              style: AppTheme.textStyles['subtitle']!.copyWith(
                fontSize: (kIsWeb ? 16.sp : 14.sp).clamp(12.0, 16.0),
                color: AppTheme.colors['secondaryText'],
              ),
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}