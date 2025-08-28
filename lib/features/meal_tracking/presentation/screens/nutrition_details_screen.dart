import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/model/food_model.dart';
import '../widgets/nutrition_details_screen_body.dart';
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
      body: NutritionDetailsScreenBody(foodItem: foodItem),
    );
  }
}
