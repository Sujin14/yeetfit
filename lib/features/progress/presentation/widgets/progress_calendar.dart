import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class ProgressCalendar extends StatelessWidget {
  const ProgressCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> activityData = List.generate(30, (index) => index % 5 / 4.0);

    return GlassmorphicContainer(
      color: const Color(0xFF26A69A),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 30 Days',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: 30,
            itemBuilder: (context, index) {
              final intensity = activityData[index];
              final color = _getColorForIntensity(intensity);
              return Tooltip(
                message: 'Day ${index + 1}: ${intensity.toStringAsFixed(2)}',
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildLegendItem('Low', Colors.red.withOpacity(0.5)),
              const SizedBox(width: 8),
              _buildLegendItem('Medium', Colors.yellow.withOpacity(0.5)),
              const SizedBox(width: 8),
              _buildLegendItem('High', Colors.green.withOpacity(0.5)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColorForIntensity(double intensity) {
    if (intensity < 0.3) {
      return Colors.red.withOpacity(0.5);
    } else if (intensity < 0.7) {
      return Colors.yellow.withOpacity(0.5);
    } else {
      return Colors.green.withOpacity(0.5);
    }
  }

  Widget _buildLegendItem(String label, Color color,) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}