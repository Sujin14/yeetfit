import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import 'package:yeetfit/shared/widgets/shimmer_line.dart';
import 'package:yeetfit/shared/widgets/shimmer_wrapper.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/food_item.dart';
import '../providers/food_log_provider.dart';
import 'food_entry_tile.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// One meal slot on the Nutrition screen; [entries] is that slot's slice of
/// today's log.
class MealSection extends ConsumerWidget {
  final String userId;
  final String title;
  final AsyncValue<List<FoodItem>> entries;
  final VoidCallback onAdd;
  final VoidCallback onRetry;
  final ValueChanged<FoodItem> onOpenEntry;

  const MealSection({
    super.key,
    required this.userId,
    required this.title,
    required this.entries,
    required this.onAdd,
    required this.onRetry,
    required this.onOpenEntry,
  });

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    FoodItem item,
  ) async {
    final entryId = item.id;
    if (entryId == null) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(foodLogControllerProvider.notifier)
          .removeEntry(userId: userId, entryId: entryId);
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text("Couldn't remove ${item.foodName}")),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final items = entries.value ?? const <FoodItem>[];
    final isLoading = !entries.hasValue && entries.isLoading;
    final hasError = !entries.hasValue && entries.hasError;
    final totalCalories = items.fold(0.0, (sum, item) => sum + item.calories);

    Widget body;
    if (isLoading) {
      body = const Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: ShimmerWrapper(
          child: Column(
            children: [
              ShimmerLine(height: 14),
              SizedBox(height: AppSpacing.sm),
              ShimmerLine(height: 14, width: 160),
            ],
          ),
        ),
      );
    } else if (hasError) {
      body = YeetErrorState.compact(
        message: "Couldn't load $title.",
        onRetry: onRetry,
      );
    } else if (items.isEmpty) {
      body = Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Text(
          'Nothing logged yet',
          style: textTheme.bodySmall!.copyWith(color: colors.textMuted),
        ),
      );
    } else {
      body = Column(
        children: [
          for (final (index, item) in items.indexed)
            FoodEntryTile(
              key: ValueKey(item.id ?? '${item.mealType}-$index'),
              item: item,
              onTap: () => onOpenEntry(item),
              onDelete: () => _delete(context, ref, item),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.smd,
          AppSpacing.smd,
          AppSpacing.smd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium!.copyWith(
                    color: colors.onBackground,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${totalCalories.round()} kcal',
                  style: textTheme.bodyMedium!.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const Spacer(),
                GlassIconButton(
                  icon: Icons.add,
                  color: colors.primary,
                  tooltip: 'Add food to $title',
                  onPressed: onAdd,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            body,
          ],
        ),
      ),
    );
  }
}
