import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';

Widget trackButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onPressed,
}) {
  final isDesktop = MediaQuery.of(context).size.width >= 600;
  final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  final onSurfaceColor = isDarkTheme
      ? AppTheme.colors['onSurfaceDark'] ?? Colors.white
      : AppTheme.colors['onSurface'] ?? Colors.black;

  return GlassmorphicContainer(
    color: color,
    padding: EdgeInsets.symmetric(
      vertical: FixedSizes.box8(context),
      horizontal: FixedSizes.box16(context),
    ),
    borderRadius: FixedSizes.radius16(context),
    child: ListTile(
      leading: Icon(
        icon,
        color: onSurfaceColor,
        size: isDesktop ? FixedSizes.icon28(context) : FixedSizes.icon24(context),
      ),
      title: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: isDesktop ? FixedSizes.font18(context) : FixedSizes.font16(context),
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
        ),
      ),
      onTap: onPressed,
    ),
  );
}
