import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class WaterProgressCard extends StatelessWidget {
  const WaterProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: const Color(0xFF26A69A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '6 / 8 Glasses',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                tooltip: 'Edit Goal',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              LinearProgressIndicator(
                value: 0.75,
                minHeight: 18,
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF3F51B5),
                backgroundColor: Colors.white.withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  '75%',
                  style: GoogleFonts.roboto(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
