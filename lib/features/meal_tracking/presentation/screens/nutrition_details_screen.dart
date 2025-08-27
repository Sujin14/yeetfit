// nutrition_details_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../data/model/food_model.dart';
import '../widgets/nutrition_header.dart';
import '../widgets/nutrition_back_button.dart';

class NutritionDetailsScreen extends StatelessWidget {
  final FoodItem foodItem;

  const NutritionDetailsScreen({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors['transparent'],
        elevation: 0,
        leading: NutritionBackButton(isLargeScreen: isWide),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? FixedSizes.box80(context) : FixedSizes.box16(context),
            vertical: FixedSizes.box24(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NutritionHeader(foodItem: foodItem),
              SizedBox(height: FixedSizes.box24(context)),
              NutritionCards(foodItem: foodItem),
            ],
          ),
        ),
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
      spacing: FixedSizes.box16(context),
      runSpacing: FixedSizes.box16(context),
      alignment: WrapAlignment.center,
      children: [
        _buildNutritionCard(
          'Calories',
          foodItem.calories,
          Icons.local_fire_department,
          AppTheme.colors['deepOrange']!,
          context,
          isWide,
        ),
        _buildNutritionCard(
          'Protein',
          foodItem.protein,
          Icons.fitness_center,
          AppTheme.colors['navBarActive']!,
          context,
          isWide,
        ),
        _buildNutritionCard(
          'Fat',
          foodItem.fat,
          Icons.oil_barrel,
          AppTheme.colors['error']!,
          context,
          isWide,
        ),
        _buildNutritionCard(
          'Carbs',
          foodItem.carbs,
          Icons.bubble_chart,
          AppTheme.colors['fullProgress']!,
          context,
          isWide,
        ),
        _buildNutritionCard(
          'Fiber',
          foodItem.fiber,
          Icons.grass,
          AppTheme.colors['indigo']!,
          context,
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
    BuildContext context,
    bool isWide,
  ) {
    return SizedBox(
      width: isWide ? FixedSizes.box300(context) : double.infinity,
      child: GlassmorphicContainer(
        color: const Color(0xFFFF5722),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            vertical: FixedSizes.box12(context),
            horizontal: FixedSizes.box16(context),
          ),
          leading: CircleAvatar(
            radius: FixedSizes.avatarRadius(context) / 2,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: FixedSizes.icon20(context)),
          ),
          title: Text(
            label,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: FixedSizes.font16(context),
              color: Colors.white,
            ),
          ),
          trailing: Text(
            value.toStringAsFixed(1),
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font18(context),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
