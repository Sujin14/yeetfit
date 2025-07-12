import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class CalorieSummary extends StatelessWidget {
  const CalorieSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: const Color(0xFFFF5722),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  value: 0.7,
                  strokeWidth: 6,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF3F51B5)),
                ),
              ),
              const Icon(
                Icons.local_dining,
                size: 28,
                color: Color(0xFF3F51B5),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1225 of 1750 Cal',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.bar_chart,
              color: Color(0xFF3F51B5),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}