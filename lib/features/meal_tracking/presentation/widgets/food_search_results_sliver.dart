import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/food_item.dart';
import '../providers/food_search_provider.dart';
import '../utils/food_search_error_message.dart';
import 'food_result_tile.dart';
import 'food_search_message.dart';
import 'food_search_shimmer.dart';

class FoodSearchResultsSliver extends ConsumerWidget {
  final String mealType;
  final ValueChanged<FoodItem> onOpenResult;

  const FoodSearchResultsSliver({
    super.key,
    required this.mealType,
    required this.onOpenResult,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(foodSearchControllerProvider);

    if (state.query.isEmpty) {
      return const SliverToBoxAdapter(
        child: FoodSearchMessage(
          icon: Icons.search_rounded,
          message: 'Search for a food to see its calories and macros.',
        ),
      );
    }

    return state.results.when(
      loading: () => const SliverToBoxAdapter(child: FoodSearchShimmer()),
      error: (error, _) => SliverToBoxAdapter(
        child: YeetErrorState(
          message: foodSearchErrorMessage(error),
          onRetry: () =>
              ref.read(foodSearchControllerProvider.notifier).retry(),
        ),
      ),
      data: (_) {
        final items = state.itemsFor(mealType);
        if (items.isEmpty) {
          return SliverToBoxAdapter(
            child: FoodSearchMessage(
              icon: Icons.no_food_outlined,
              message: 'No results for "${state.query}".',
            ),
          );
        }
        return SliverList.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => FoodResultTile(
            item: items[index],
            onTap: () => onOpenResult(items[index]),
          ),
        );
      },
    );
  }
}
