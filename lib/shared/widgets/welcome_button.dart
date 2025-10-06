import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/theme.dart';

class WelcomeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isPrimary;
  final IconData? icon;

  const WelcomeButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isPrimary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme;
    final buttonColor = backgroundColor ?? AppTheme.colors['primaryAccent']!;
    final textColor = foregroundColor ?? AppTheme.colors['white']!;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20.sp, color: textColor),
        label: Text(
          label,
          style: AppTheme.textStyles['body']!.copyWith(
            color: textColor,
            fontSize: 16.sp,
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? buttonColor : Colors.transparent,
          foregroundColor: isPrimary ? textColor : buttonColor,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: buttonColor, width: 2.w),
          ),
          elevation: isPrimary ? 2 : 0,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
