import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_theme.dart';
import 'admin_theme.dart';

enum AppRole { user, admin }

class AppTheme {
  static ThemeData getLightTheme(AppRole role) {
    final isUser = role == AppRole.user;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: isUser
          ? UserTheme.lightBackground
          : AdminTheme.lightBackground,
      colorScheme: ColorScheme.light(
        primary: isUser ? UserTheme.primaryButton : AdminTheme.primaryButton,
        secondary: isUser
            ? UserTheme.navigationAccent
            : AdminTheme.navigationAccent,
        surface: isUser
            ? UserTheme.lightBackground
            : AdminTheme.lightBackground,
      ),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        headlineLarge: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.roboto(fontSize: 14),
      ),
    );
  }

  static ThemeData getDarkTheme(AppRole role) {
    final isUser = role == AppRole.user;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: isUser
          ? UserTheme.darkText
          : AdminTheme.darkText,
      colorScheme: ColorScheme.dark(
        primary: isUser ? UserTheme.primaryButton : AdminTheme.primaryButton,
        secondary: isUser
            ? UserTheme.navigationAccent
            : AdminTheme.navigationAccent,
        surface: isUser ? UserTheme.darkText : AdminTheme.darkText,
      ),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        headlineLarge: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.roboto(fontSize: 14),
      ),
    );
  }
}
