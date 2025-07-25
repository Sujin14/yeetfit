import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            const Color(0xFF26A69A).withOpacity(0.3),
            const Color(0xFF3F51B5).withOpacity(0.3),
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
            color: Colors.grey.withOpacity(0.3),
            // Comment: This is a placeholder for the food image
          ),
          Text(
            'Sample Food',
            style: GoogleFonts.righteous(
              fontSize: isLargeScreen ? 32 : size.width * 0.06,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nutritional Details',
            style: GoogleFonts.roboto(
              fontSize: isLargeScreen ? 18 : size.width * 0.035,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
