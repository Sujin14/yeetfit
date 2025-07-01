import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const colors = {
    'lightBackground': Color(0xFFEAF1F8),
    'darkBackground': Color(0xFF0E0E11),
    'primaryAccent': Color(0xFF8EC5FC),
    'secondaryAccent': Color(0xFFE0C3FC),
    'primaryButton': Color(0xFF8EC5FC),
    'primaryText': Color(0xFF212121),
    'secondaryText': Color(0xFF616161),
    'error': Color(0xFFD32F2F),
    'navigationAccent': Color.fromRGBO(142, 197, 252, 0.2),
    'navBarActive': Color.fromARGB(255, 3, 104, 205),
    'navBarInactiveOpacity': Color.fromRGBO(97, 97, 97, 0.6),
    'borderGradientStart': Color.fromRGBO(142, 197, 252, 0.3),
    'borderGradientEnd': Color.fromRGBO(224, 195, 252, 0.3),
    'gradientTextStart': Color(0xFF8EC5FC),
    'gradientTextMiddle': Color.fromRGBO(142, 197, 252, 0.7),
    'gradientTextEnd': Color(0xFFE0C3FC),
  };

  static final textStyles = {
    'heading': GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold),
    'title': GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600),
    'subtitle': GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
    'body': GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
    'caption': GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w300),
  };

  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors['lightBackground'],
      colorScheme: ColorScheme.light(
        primary: colors['primaryAccent']!,
        secondary: colors['secondaryAccent']!,
        surface: colors['lightBackground']!,
        error: colors['error']!,
        onPrimary: colors['primaryText']!,
        onSecondary: colors['primaryText']!,
        onSurface: colors['primaryText']!,
        onError: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primaryButton'],
          foregroundColor: colors['primaryText'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        headlineLarge: textStyles['heading']!.copyWith(
          color: colors['primaryText'],
        ),
        titleMedium: textStyles['title']!.copyWith(
          color: colors['primaryText'],
        ),
        bodyMedium: textStyles['body']!.copyWith(color: colors['primaryText']),
        bodySmall: textStyles['caption']!.copyWith(
          color: colors['secondaryText'],
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colors['primaryText']),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors['darkBackground'],
      colorScheme: ColorScheme.dark(
        primary: colors['primaryAccent']!,
        secondary: colors['secondaryAccent']!,
        surface: colors['darkBackground']!,
        error: colors['error']!,
        onPrimary: Color.fromRGBO(255, 255, 255, 0.9),
        onSecondary: Color.fromRGBO(255, 255, 255, 0.9),
        onSurface: Color.fromRGBO(255, 255, 255, 0.9),
        onError: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primaryButton'],
          foregroundColor: Color.fromRGBO(255, 255, 255, 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            headlineLarge: textStyles['heading']!.copyWith(
              color: Color.fromRGBO(255, 255, 255, 0.9),
            ),
            titleMedium: textStyles['title']!.copyWith(
              color: Color.fromRGBO(255, 255, 255, 0.9),
            ),
            bodyMedium: textStyles['body']!.copyWith(
              color: Color.fromRGBO(255, 255, 255, 0.9),
            ),
            bodySmall: textStyles['caption']!.copyWith(
              color: Color.fromRGBO(255, 255, 255, 0.6),
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(255, 255, 255, 0.9)),
      ),
    );
  }
}
