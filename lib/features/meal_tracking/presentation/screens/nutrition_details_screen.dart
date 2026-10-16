import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import '../../domain/entities/food_item.dart';
import '../widgets/nutrition_add_button.dart';
import '../widgets/nutrition_header.dart';
import '../widgets/nutrition_macro_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Nutrition for one food. Unsaved search results ([FoodItem.id] is null)
/// get an "Add to log" action that pops `true` once logged.
class NutritionDetailsScreen extends ConsumerWidget {
  final FoodItem foodItem;

  const NutritionDetailsScreen({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    final canAdd = foodItem.id == null && userId != null;

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: canAdd
            ? NutritionAddButton(
                userId: userId,
                foodItem: foodItem,
                onAdded: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added ${foodItem.foodName} to ${foodItem.mealType}',
                      ),
                    ),
                  );
                  context.pop(true);
                },
              )
            : null,
        body: CustomScrollView(
          slivers: [
            const GlassSliverAppBar(title: 'Nutrition Details'),
            SliverToBoxAdapter(child: NutritionHeader(foodItem: foodItem)),
            SliverToBoxAdapter(child: NutritionMacroCard(foodItem: foodItem)),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          ],
        ),
      ),
    );
  }
}
