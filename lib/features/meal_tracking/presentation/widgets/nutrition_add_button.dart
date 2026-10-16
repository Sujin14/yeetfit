import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import '../../domain/entities/food_item.dart';
import '../providers/food_log_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Bottom "Add to log" action; calls [onAdded] once the entry is saved.
class NutritionAddButton extends ConsumerWidget {
  final String userId;
  final FoodItem foodItem;
  final VoidCallback onAdded;

  const NutritionAddButton({
    super.key,
    required this.userId,
    required this.foodItem,
    required this.onAdded,
  });

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final added = await ref
        .read(foodLogControllerProvider.notifier)
        .addToLog(userId: userId, item: foodItem);
    if (added) {
      onAdded();
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Couldn't add ${foodItem.foodName}. Try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaving = ref.watch(foodLogControllerProvider).isLoading;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          AppSpacing.sm,
          AppSpacing.screenEdge,
          AppSpacing.md,
        ),
        child: GradientButton(
          label: 'Add to log',
          isLoading: isSaving,
          onPressed: isSaving ? null : () => _add(context, ref),
        ),
      ),
    );
  }
}
