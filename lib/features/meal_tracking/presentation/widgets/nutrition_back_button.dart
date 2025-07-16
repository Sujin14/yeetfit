import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class NutritionBackButton extends StatelessWidget {
  final bool isLargeScreen;

  const NutritionBackButton({super.key, required this.isLargeScreen});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: isLargeScreen ? 300 : double.infinity,
        child: GlassmorphicContainer(
          color: const Color(0xFF3F51B5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back',
              style: GoogleFonts.roboto(
                fontSize: isLargeScreen ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}