import 'package:flutter/material.dart';
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
        background: isUser
            ? UserTheme.lightBackground
            : AdminTheme.lightBackground,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14),
      ),
    );
  }

  static ThemeData getDarkTheme(AppRole role) {
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: role == AppRole.user
          ? UserTheme.darkText
          : AdminTheme.darkText,
      colorScheme: ColorScheme.dark(
        background: role == AppRole.user
            ? UserTheme.darkText
            : AdminTheme.darkText,
        primary: role == AppRole.user
            ? UserTheme.primaryButton
            : AdminTheme.primaryButton,
        secondary: role == AppRole.user
            ? UserTheme.navigationAccent
            : AdminTheme.navigationAccent,
      ),
    );
  }
}
