// Main ThemeData with light/dark + extensions
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      extensions: const [AppColors.light],
      colorScheme: ColorScheme.light(
        primary: AppColors.light.primary,
        secondary: AppColors.light.secondary,
        surface: AppColors.light.surface,
        error: AppColors.light.error,
        onPrimary: AppColors.light.onBackground,
        onSecondary: AppColors.light.onBackground,
        onSurface: AppColors.light.onSurface,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.light.background,
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        headlineLarge: AppTextStyles.heading.copyWith(color: AppColors.light.onBackground),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.light.onBackground),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.light.onBackground),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.light.onBackground.withOpacity(0.6)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.light.primary,
          foregroundColor: AppColors.light.onBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.light.borderStart),
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: const [AppColors.dark],
      colorScheme: ColorScheme.dark(
        primary: AppColors.dark.primary,
        secondary: AppColors.dark.secondary,
        surface: AppColors.dark.surface,
        error: AppColors.dark.error,
        onPrimary: AppColors.dark.onSurface,
        onSecondary: AppColors.dark.onSurface,
        onSurface: AppColors.dark.onSurface,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.dark.background,
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
        headlineLarge: AppTextStyles.heading.copyWith(color: AppColors.dark.onSurface),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.dark.onSurface),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.dark.onSurface),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.6)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.dark.primary,
          foregroundColor: AppColors.dark.onSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.dark.borderStart),
        ),
      ),
    );
  }
}