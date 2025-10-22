// Centralized widget styling constants.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/theme/theme.dart';

class WidgetStyles {
  static EdgeInsets buttonPadding(bool isWeb) =>
      EdgeInsets.symmetric(vertical: isWeb ? 16.h : 14.h);

  static BorderRadius buttonBorderRadius() => BorderRadius.circular(12.r);

  static BorderSide transparentBorder() =>
      BorderSide(color: AppTheme.colors['transparent']!);

  static TextStyle buttonTextStyle() => AppTheme.textStyles['body']!.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppTheme.colors['primaryText'],
  );

  static TextStyle linkTextStyle(bool isWeb) =>
      AppTheme.textStyles['body']!.copyWith(
        fontSize: (isWeb ? 14.sp : 12.sp).clamp(10.0, 14.0),
        fontWeight: FontWeight.bold,
        color: AppTheme.colors['primaryAccent'],
      );

  static EdgeInsets formPadding(bool isWeb) =>
      EdgeInsets.symmetric(horizontal: isWeb ? 40.w : 24.w, vertical: 24.h);

  static BorderRadius containerBorderRadius() => BorderRadius.only(
    topLeft: Radius.circular(30.r),
    topRight: Radius.circular(30.r),
  );
}
