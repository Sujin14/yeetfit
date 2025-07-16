import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class FoodList extends StatelessWidget {
  const FoodList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return GlassmorphicContainer(
            color: const Color(0xFFFF5722),
            padding: const EdgeInsets.all(12),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Sample Food $index',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                'Calories: 200 kcal\nProtein: 10g, Fat: 5g, Carbs: 30g',
                style: GoogleFonts.roboto(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Color(0xFF26A69A),
                ),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}