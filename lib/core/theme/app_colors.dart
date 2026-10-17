// Central color palette for both themes
// Use via Theme.of(context).extension<AppColors>()!
import 'package:flutter/material.dart';
import 'package:yeetfit/core/entities/progress_level.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceGlass,
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.secondaryVariant,
    required this.gradientStart,
    required this.gradientMid,
    required this.gradientEnd,
    required this.onBackground,
    required this.onSurface,
    required this.onPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.subtle,
    required this.divider,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.borderStart,
    required this.borderEnd,
    required this.navAccent,
    required this.progressFull,
    required this.progress75,
    required this.progress50,
    required this.progress25,
    required this.progressNone,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.bmiUnderweight,
    required this.bmiNormal,
    required this.bmiOverweight,
    required this.bmiObese,
  });

  final Color background;
  final Color surface;
  final Color surfaceGlass;
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color gradientStart;
  final Color gradientMid;
  final Color gradientEnd;
  final Color onBackground;
  final Color onSurface;
  final Color onPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color subtle;
  final Color divider;
  final Color error;
  final Color success;
  final Color warning;
  final Color info;
  final Color borderStart;
  final Color borderEnd;
  final Color navAccent;
  final Color progressFull;
  final Color progress75;
  final Color progress50;
  final Color progress25;
  final Color progressNone;
  final Color calories;
  final Color protein;
  final Color carbs;
  final Color fat;
  final Color bmiUnderweight;
  final Color bmiNormal;
  final Color bmiOverweight;
  final Color bmiObese;

  Color progressColor(ProgressLevel level) {
    switch (level) {
      case ProgressLevel.none:
        return progressNone;
      case ProgressLevel.quarter:
        return progress25;
      case ProgressLevel.half:
        return progress50;
      case ProgressLevel.threeQuarter:
        return progress75;
      case ProgressLevel.full:
        return progressFull;
    }
  }

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceGlass,
    Color? primary,
    Color? primaryVariant,
    Color? secondary,
    Color? secondaryVariant,
    Color? gradientStart,
    Color? gradientMid,
    Color? gradientEnd,
    Color? onBackground,
    Color? onSurface,
    Color? onPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? subtle,
    Color? divider,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
    Color? borderStart,
    Color? borderEnd,
    Color? navAccent,
    Color? progressFull,
    Color? progress75,
    Color? progress50,
    Color? progress25,
    Color? progressNone,
    Color? calories,
    Color? protein,
    Color? carbs,
    Color? fat,
    Color? bmiUnderweight,
    Color? bmiNormal,
    Color? bmiOverweight,
    Color? bmiObese,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceGlass: surfaceGlass ?? this.surfaceGlass,
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      secondary: secondary ?? this.secondary,
      secondaryVariant: secondaryVariant ?? this.secondaryVariant,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientMid: gradientMid ?? this.gradientMid,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      onPrimary: onPrimary ?? this.onPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      subtle: subtle ?? this.subtle,
      divider: divider ?? this.divider,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      borderStart: borderStart ?? this.borderStart,
      borderEnd: borderEnd ?? this.borderEnd,
      navAccent: navAccent ?? this.navAccent,
      progressFull: progressFull ?? this.progressFull,
      progress75: progress75 ?? this.progress75,
      progress50: progress50 ?? this.progress50,
      progress25: progress25 ?? this.progress25,
      progressNone: progressNone ?? this.progressNone,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      bmiUnderweight: bmiUnderweight ?? this.bmiUnderweight,
      bmiNormal: bmiNormal ?? this.bmiNormal,
      bmiOverweight: bmiOverweight ?? this.bmiOverweight,
      bmiObese: bmiObese ?? this.bmiObese,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceGlass: Color.lerp(surfaceGlass, other.surfaceGlass, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryVariant: Color.lerp(
        secondaryVariant,
        other.secondaryVariant,
        t,
      )!,
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientMid: Color.lerp(gradientMid, other.gradientMid, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      subtle: Color.lerp(subtle, other.subtle, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      borderStart: Color.lerp(borderStart, other.borderStart, t)!,
      borderEnd: Color.lerp(borderEnd, other.borderEnd, t)!,
      navAccent: Color.lerp(navAccent, other.navAccent, t)!,
      progressFull: Color.lerp(progressFull, other.progressFull, t)!,
      progress75: Color.lerp(progress75, other.progress75, t)!,
      progress50: Color.lerp(progress50, other.progress50, t)!,
      progress25: Color.lerp(progress25, other.progress25, t)!,
      progressNone: Color.lerp(progressNone, other.progressNone, t)!,
      calories: Color.lerp(calories, other.calories, t)!,
      protein: Color.lerp(protein, other.protein, t)!,
      carbs: Color.lerp(carbs, other.carbs, t)!,
      fat: Color.lerp(fat, other.fat, t)!,
      bmiUnderweight: Color.lerp(bmiUnderweight, other.bmiUnderweight, t)!,
      bmiNormal: Color.lerp(bmiNormal, other.bmiNormal, t)!,
      bmiOverweight: Color.lerp(bmiOverweight, other.bmiOverweight, t)!,
      bmiObese: Color.lerp(bmiObese, other.bmiObese, t)!,
    );
  }

  // Dark Theme (primary — Yeetfit is dark-first)
  static const dark = AppColors(
    background: Color(0xFF0A0A1A),
    surface: Color(0xFF12122A),
    surfaceGlass: Color(0x1AFFFFFF),
    primary: Color(0xFF6C63FF),
    primaryVariant: Color(0xFF8B83FF),
    secondary: Color(0xFF00D4FF),
    secondaryVariant: Color(0xFF00A8CC),
    gradientStart: Color(0xFF1A1A3E),
    gradientMid: Color(0xFF16213E),
    gradientEnd: Color(0xFF0F3460),
    onBackground: Color(0xFFF0F0FF),
    onSurface: Color(0xFFE0E0F5),
    onPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFAAABC8),
    textMuted: Color(0xFF6B6C8A),
    subtle: Color(0xFF9A9BB4),
    divider: Color(0xFF3A3B55),
    error: Color(0xFFFF5C7A),
    success: Color(0xFF4DFFA0),
    warning: Color(0xFFFFD166),
    info: Color(0xFF00D4FF),
    borderStart: Color(0x336C63FF),
    borderEnd: Color(0x3300D4FF),
    navAccent: Color(0xFF6C63FF),
    progressFull: Color(0xFF4DFFA0),
    progress75: Color(0xFF7BF1A8),
    progress50: Color(0xFFFFD166),
    progress25: Color(0xFFFF9F43),
    progressNone: Color(0xFFFF5C7A),
    calories: Color(0xFF00D4FF),
    protein: Color(0xFF4DFFA0),
    carbs: Color(0xFFFFD166),
    fat: Color(0xFFFF9F43),
    bmiUnderweight: Color(0xFF00D4FF),
    bmiNormal: Color(0xFF4DFFA0),
    bmiOverweight: Color(0xFFFFD166),
    bmiObese: Color(0xFFFF5C7A),
  );

  // Light Theme
  static const light = AppColors(
    background: Color(0xFFF5F5FF),
    surface: Color(0xFFFFFFFF),
    surfaceGlass: Color(0x1A000040),
    primary: Color(0xFF5B52F0),
    primaryVariant: Color(0xFF7B73FF),
    secondary: Color(0xFF0099CC),
    secondaryVariant: Color(0xFF007AA8),
    gradientStart: Color(0xFFE8E8FF),
    gradientMid: Color(0xFFD4D4F5),
    gradientEnd: Color(0xFFC5D5F0),
    onBackground: Color(0xFF0D0D2B),
    onSurface: Color(0xFF1A1A3E),
    onPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF555577),
    textMuted: Color(0xFF8888AA),
    subtle: Color(0xFF6B7280),
    divider: Color(0xFFE5E7EB),
    error: Color(0xFFD63060),
    success: Color(0xFF00A86B),
    warning: Color(0xFFE6A817),
    info: Color(0xFF0099CC),
    borderStart: Color(0x335B52F0),
    borderEnd: Color(0x330099CC),
    navAccent: Color(0xFF5B52F0),
    progressFull: Color(0xFF4DFFA0),
    progress75: Color(0xFF7BF1A8),
    progress50: Color(0xFFFFD166),
    progress25: Color(0xFFFF9F43),
    progressNone: Color(0xFFFF5C7A),
    calories: Color(0xFF00D4FF),
    protein: Color(0xFF4DFFA0),
    carbs: Color(0xFFFFD166),
    fat: Color(0xFFFF9F43),
    bmiUnderweight: Color(0xFF00D4FF),
    bmiNormal: Color(0xFF4DFFA0),
    bmiOverweight: Color(0xFFFFD166),
    bmiObese: Color(0xFFFF5C7A),
  );
}
