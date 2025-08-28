import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../widgets/food_search_screen_body.dart';
import '../widgets/manual_add_button.dart';

class FoodSearchScreen extends ConsumerWidget {
  final String mealType;

  const FoodSearchScreen({super.key, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors['transparent'],
        elevation: 0,
        title: Text(
          'Search Food - $mealType',
          style: TextStyle(color: AppTheme.colors['onSurface']),
        ),
      ),
      body: FoodSearchScreenBody(mealType: mealType),
      floatingActionButton: ManualAddButton(mealType: mealType),
    );
  }
}