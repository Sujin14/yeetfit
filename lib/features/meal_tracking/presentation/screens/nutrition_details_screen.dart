import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../data/model/food_model.dart';
import '../widgets/nutrition_header.dart';

class NutritionDetailsScreen extends StatelessWidget {
  final FoodItem foodItem;

  const NutritionDetailsScreen({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NutritionHeader(foodItem: foodItem),
                  SizedBox(height: 24),
                  NutritionCards(foodItem: foodItem),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class NutritionCards extends StatelessWidget {
  final FoodItem foodItem;

  const NutritionCards({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildNutritionCard(
          'Calories',
          foodItem.calories,
          Icons.local_fire_department,
          AppTheme.colors['deepOrange']!,
          isWide,
        ),
        _buildNutritionCard(
          'Protein',
          foodItem.protein,
          Icons.fitness_center,
          AppTheme.colors['navBarActive']!,
          isWide,
        ),
        _buildNutritionCard(
          'Fat',
          foodItem.fat,
          Icons.oil_barrel,
          AppTheme.colors['error']!,
          isWide,
        ),
        _buildNutritionCard(
          'Carbs',
          foodItem.carbs,
          Icons.bubble_chart,
          AppTheme.colors['fullProgress']!,
          isWide,
        ),
        _buildNutritionCard(
          'Fiber',
          foodItem.fiber,
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
        color: const Color(0xFFFF5722),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          title: Text(
            label,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
