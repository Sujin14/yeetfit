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
    'deepOrange': Color(0xFFFF5722),
    'teal': Color(0xFF26A69A),
    'indigo': Color(0xFF3F51B5),
    'onSurface': Color(0xFF212121),
    'onSurfaceDark': Color.fromRGBO(245, 245, 245, 0.9),
    'fullProgress': Color.fromARGB(255, 4, 160, 10),
    'ThreeQuarterProgress': Color.fromARGB(255, 88, 184, 92),
    'halfProgress': Color(0xFFFFEB3B),
    'QuarterProgress': Color(0xFFFF9800),
    'noProgress': Color(0xFFF44336),
    'waterChartBackground': Color(0xFF3F51B5),
    'white': Colors.white,
    'black': Colors.black,
    'gray': Colors.grey,
    'transparent': Colors.transparent,
    'aquaBlue': Color.fromARGB(255, 89, 196, 245),
  };

  static final textStyles = {
    'heading': GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold),
    'title': GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600),
    'titleMedium': GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500),
    'subtitle': GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
    'body': GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
    'bodyMedium': GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.normal),
    'bodySmall': GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.normal),
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
        onSurface: colors['onSurface']!,
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
        headlineLarge: textStyles['heading']!.copyWith(color: colors['primaryText']),
        titleMedium: textStyles['titleMedium']!.copyWith(color: colors['primaryText']),
        bodyMedium: textStyles['bodyMedium']!.copyWith(color: colors['primaryText']),
        bodySmall: textStyles['bodySmall']!.copyWith(color: colors['secondaryText']),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colors['primaryText']),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors['borderGradientStart']!),
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors['darkBackground'],
      colorScheme: ColorScheme.dark(
        primary: colors['teal']!,
        secondary: colors['deepOrange']!,
        tertiary: colors['indigo']!,
        surface: colors['darkBackground']!,
        error: colors['error']!,
        onPrimary: colors['onSurfaceDark']!,
        onSecondary: colors['onSurfaceDark']!,
        onSurface: colors['onSurfaceDark']!,
        onError: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primaryButton'],
          foregroundColor: colors['onSurfaceDark'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
        headlineLarge: textStyles['heading']!.copyWith(color: colors['onSurfaceDark']),
        titleMedium: textStyles['titleMedium']!.copyWith(color: colors['onSurfaceDark']),
        bodyMedium: textStyles['bodyMedium']!.copyWith(color: colors['onSurfaceDark']),
        bodySmall: textStyles['bodySmall']!.copyWith(color: Color.fromRGBO(255, 255, 255, 0.6)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colors['onSurfaceDark']),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors['borderGradientStart']!),
        ),
      ),
    );
  }
}