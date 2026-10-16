import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../providers/food_search_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Search box plus the serving size (grams) results are scaled to.
class FoodSearchField extends ConsumerWidget {
  const FoodSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(foodSearchControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.smd,
      ),
      child: Row(
        children: [
          Expanded(
            child: YeetTextField(
              hintText: 'Search foods',
              prefixIcon: Icons.search,
              textInputAction: TextInputAction.search,
              onChanged: controller.updateQuery,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 96,
            child: YeetTextField(
              hintText: '100 g',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              onChanged: controller.updateQuantity,
            ),
          ),
        ],
      ),
    );
  }
}
