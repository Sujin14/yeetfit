import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class MealSection extends StatelessWidget {
  final String mealType;

  const MealSection({super.key, required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              mealType,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '300 of 438 Cal',
                  style: GoogleFonts.roboto(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFF26A69A)),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        GlassmorphicContainer(
          color: const Color(0xFFFF5722),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Add Your Food for $mealType to Track your Calorie intake🔥😋',
                  style: GoogleFonts.roboto(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}