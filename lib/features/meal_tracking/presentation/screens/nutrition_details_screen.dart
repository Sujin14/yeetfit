import 'package:flutter/material.dart';

import '../widgets/nutrition_back_button.dart';
import '../widgets/nutrition_card.dart';
import '../widgets/nutrition_header.dart';


class NutritionDetailsScreen extends StatelessWidget {
  const NutritionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NutritionHeader(),
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
                  const NutritionCards(),
                  const SizedBox(height: 40),
                  NutritionBackButton(isLargeScreen: isWide),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
