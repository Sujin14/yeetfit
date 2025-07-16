import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class WaterCircularIndicator extends StatelessWidget {
  const WaterCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 20,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF3F51B5)),
                ),
              ),
              GlassmorphicContainer(
                color: const Color(0xFF26A69A),
                padding: const EdgeInsets.all(0),
                borderRadius: 40,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(
                    Icons.water_drop_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '1 Glass = 250 ml',
            style: GoogleFonts.roboto(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
