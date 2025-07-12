import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsCaloriesCard extends StatelessWidget {
  const StepsCaloriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calories Burned',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 16 : 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Goal:',
                style: GoogleFonts.roboto(
                  fontSize: isDesktop ? 14 : 14,
                  color: Colors.white70,
                ),
              ),
              Text(
                '400 Cal 🔥',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 14 : 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Burn:',
                style: GoogleFonts.roboto(
                  fontSize: isDesktop ? 14 : 14,
                  color: Colors.white70,
                ),
              ),
              Text(
                '300 Cal 🔥',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 14 : 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}