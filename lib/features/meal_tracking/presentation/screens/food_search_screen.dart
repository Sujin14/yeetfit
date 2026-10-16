import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/core/routes/tracking_routes_constants.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../widgets/food_search_field.dart';
import '../widgets/food_search_results_sliver.dart';
import '../widgets/manual_add_button.dart';
import '../widgets/manual_food_entry_dialog.dart';

class FoodSearchScreen extends ConsumerWidget {
  final String mealType;

  const FoodSearchScreen({super.key, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: userId == null
            ? null
            : ManualAddButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) =>
                      ManualFoodEntryDialog(userId: userId, mealType: mealType),
                ),
              ),
        body: userId == null
            ? const SignInRequiredView(message: 'Please log in to add food')
            : CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  GlassSliverAppBar(title: 'Add to $mealType'),
                  const SliverToBoxAdapter(child: FoodSearchField()),
                  FoodSearchResultsSliver(
                    mealType: mealType,
                    onOpenResult: (item) async {
                      final added = await context.push<bool>(
                        TrackingRouteConstants.nutritionDetails,
                        extra: item,
                      );
                      if (added == true && context.mounted) context.pop();
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
      ),
    );
  }
}
