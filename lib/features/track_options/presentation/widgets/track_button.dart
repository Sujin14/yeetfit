import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

Widget trackButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final isDesktop = MediaQuery.of(context).size.width >= 600.w;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final onSurfaceColor = isDarkTheme
        ? AppTheme.colors['onSurfaceDark'] ?? Colors.white
        : AppTheme.colors['onSurface'] ?? Colors.black;

    return GlassmorphicContainer(
      color: color,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      borderRadius: 16.r,
      child: ListTile(
        leading: Icon(
          icon,
          color: onSurfaceColor,
          size: isDesktop ? 28.sp : 24.sp,
        ),
        title: Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: isDesktop ? 18.sp : 16.sp,
            fontWeight: FontWeight.bold,
            color: onSurfaceColor,
          ),
        ),
        onTap: onPressed,
      ),
    );
  }