import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class NutritionCards extends StatelessWidget {
  const NutritionCards({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildNutritionCard(
          'Calories',
          200,
          Icons.local_fire_department,
          AppTheme.colors['deepOrange']!,
          isWide,
        ),
        _buildNutritionCard(
          'Protein',
          15,
          Icons.fitness_center,
          AppTheme.colors['navBarActive']!,
          isWide,
        ),
        _buildNutritionCard(
          'Fat',
          10,
          Icons.oil_barrel,
          AppTheme.colors['error']!,
          isWide,
        ),
        _buildNutritionCard(
          'Carbs',
          30,
          Icons.bubble_chart,
          AppTheme.colors['fullProgress']!,
          isWide,
        ),
        _buildNutritionCard(
          'Fiber',
          5,
          Icons.grass,
          AppTheme.colors['indigo']!,
          isWide,
        ),
      ],
    );
  }

  Widget _buildNutritionCard(
    String label,
    double value,
    IconData icon,
    Color color,
    bool isWide,
  ) {
    return SizedBox(
      width: isWide ? 300 : double.infinity,
      child: GlassmorphicContainer(
        color: AppTheme.colors['deepOrange']!,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          title: Text(
            label,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['primaryColor'],
            ),
          ),
          trailing: Text(
            value.toStringAsFixed(1),
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}