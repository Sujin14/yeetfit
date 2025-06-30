import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const colors = {
    'lightBackground': Color(0xFFFFF3E2),
    'cardBackground': Color(0xFFFFE8C2),
    'primaryButton': Color(0xFFFEC674),
    'navigationAccent': Color(0xFFFBAB57),
    'hoverAccent': Color(0xFFF06292),
    'borderText': Color(0xFFD7CCC8),
    'darkText': Color(0xFF222222),
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
        primary: colors['primaryButton']!,
        secondary: colors['navigationAccent']!,
        surface: colors['lightBackground']!,
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
