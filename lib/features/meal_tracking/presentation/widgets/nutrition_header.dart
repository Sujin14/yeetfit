import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/theme.dart';

class NutritionHeader extends StatelessWidget implements PreferredSizeWidget {
  const NutritionHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(150);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;

    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.colors['teal']!.withOpacity(0.3),
            AppTheme.colors['indigo']!.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: size.height * 0.07,
        left: isLargeScreen ? 60 : size.width * 0.05,
        right: isLargeScreen ? 60 : size.width * 0.05,
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for food image
          Container(
            width: 50,
            height: 50,
            color: AppTheme.colors['gray']!.withOpacity(0.3),
          ),
          Text(
            'Sample Food',
            style: GoogleFonts.righteous(
              fontSize: isLargeScreen ? 32 : size.width * 0.06,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nutritional Details',
            style: GoogleFonts.roboto(
              fontSize: isLargeScreen ? 18 : size.width * 0.035,
              color: AppTheme.colors['onSurface']!.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}