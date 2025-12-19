// Central color palette for both themes
// Use via Theme.of(context).extension<AppColors>()!
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.onBackground,
    required this.onSurface,
    required this.error,
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
  final Color primary;
  final Color secondary;
  final Color onBackground;
  final Color onSurface;
  final Color error;
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

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? primary,
    Color? secondary,
    Color? onBackground,
    Color? onSurface,
    Color? error,
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
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      error: error ?? this.error,
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
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      error: Color.lerp(error, other.error, t)!,
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

  // Light Theme
  static const light = AppColors(
    background: Color(0xFFEAF1F8),
    surface: Color(0xFFEAF1F8),
    primary: Color(0xFF8EC5FC),
    secondary: Color(0xFFE0C3FC),
    onBackground: Color(0xFF212121),
    onSurface: Color(0xFF212121),
    error: Color.fromARGB(255, 211, 47, 47),
    borderStart: Color.fromRGBO(142, 197, 252, 0.3),
    borderEnd: Color.fromRGBO(224, 195, 252, 0.3),
    navAccent: Color.fromRGBO(142, 197, 252, 0.2),
    progressFull: Color.fromARGB(255, 4, 160, 10),
    progress75: Color.fromARGB(255, 88, 184, 92),
    progress50: Color(0xFFFFEB3B),
    progress25: Color(0xFFFF9800),
    progressNone: Color(0xFFF44336),
    calories: Color(0xFF2196F3),
    protein: Color(0xFF4CAF50),
    carbs: Color(0xFFFFEB3B),
    fat: Color(0xFFF44336),
    bmiUnderweight: Color(0xFFFF6B6B),
    bmiNormal: Color(0xFF4CAF50),
    bmiOverweight: Color(0xFFFFD700),
    bmiObese: Color(0xFFFFB347),
  );

  // Dark Theme
  static const dark = AppColors(
    background: Color(0xFF0E0E11),
    surface: Color(0xFF0E0E11),
    primary: Color(0xFF26A69A),
    secondary: Color(0xFFFF5722),
    onBackground: Color.fromRGBO(245, 245, 245, 0.9),
    onSurface: Color.fromRGBO(245, 245, 245, 0.9),
    error: Color.fromARGB(255, 211, 47, 47),
    borderStart: Color.fromRGBO(142, 197, 252, 0.3),
    borderEnd: Color.fromRGBO(224, 195, 252, 0.3),
    navAccent: Color.fromRGBO(142, 197, 252, 0.2),
    progressFull: Color.fromARGB(255, 4, 160, 10),
    progress75: Color.fromARGB(255, 88, 184, 92),
    progress50: Color(0xFFFFEB3B),
    progress25: Color(0xFFFF9800),
    progressNone: Color(0xFFF44336),
    calories: Color(0xFF2196F3),
    protein: Color(0xFF4CAF50),
    carbs: Color(0xFFFFEB3B),
    fat: Color(0xFFF44336),
    bmiUnderweight: Color(0xFFFF6B6B),
    bmiNormal: Color(0xFF4CAF50),
    bmiOverweight: Color(0xFFFFD700),
    bmiObese: Color(0xFFFFB347),
  );
}
