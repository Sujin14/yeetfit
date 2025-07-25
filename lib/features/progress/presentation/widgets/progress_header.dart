import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Progress Heatmap',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          DropdownButton<String>(
            value: 'All Metrics',
            dropdownColor: const Color(0xFF3F51B5).withOpacity(0.5),
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: isDesktop ? 16 : 14,
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            underline: const SizedBox(),
            onChanged: (value) {},
            items: const [
              DropdownMenuItem(
                value: 'All Metrics',
                child: Text('All Metrics', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'Meal Tracking',
                child: Text('Meal Tracking', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'Sleep',
                child: Text('Sleep', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'Steps',
                child: Text('Steps', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'Water',
                child: Text('Water', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'Weight',
                child: Text('Weight', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}