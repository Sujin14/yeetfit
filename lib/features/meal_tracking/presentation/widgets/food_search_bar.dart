import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class FoodSearchBar extends StatelessWidget {
  const FoodSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: const Color(0xFF26A69A),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Enter food name',
          labelStyle: GoogleFonts.roboto(color: Colors.white70),
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: const Icon(Icons.fastfood, color: Colors.white),
          suffixIcon: const Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
        ),
        style: GoogleFonts.roboto(color: Colors.white),
      ),
    );
  }
}