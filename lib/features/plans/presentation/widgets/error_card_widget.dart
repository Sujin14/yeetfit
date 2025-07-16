import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';

class ErrorCardWidget extends StatelessWidget {
  final String error;

  const ErrorCardWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 200.h,
      borderRadius: 20.r,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.colors['navigationAccent']!,
          AppTheme.colors['navigationAccent']!.withOpacity(0.8),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['borderGradientStart']!,
          AppTheme.colors['borderGradientEnd']!,
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Text(
          'Error: $error',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['error'],
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
