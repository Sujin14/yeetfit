import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class ManualAddButton extends StatelessWidget {
  const ManualAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add),
        label: Text(
          'Add Food',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}