import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/yeet_confirm_dialog.dart';
import '../../domain/entities/food_item.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class FoodEntryTile extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FoodEntryTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.xs),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.foodName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium!.copyWith(
                  color: colors.onBackground,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${item.calories.round()} kcal',
              style: textTheme.bodySmall!.copyWith(color: colors.textSecondary),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: 18,
              color: colors.textMuted,
              tooltip: 'Remove ${item.foodName}',
              visualDensity: VisualDensity.compact,
              onPressed: () async {
                final confirmed = await showYeetConfirmDialog(
                  context,
                  title: 'Remove food?',
                  message: "Remove this entry from today's log?",
                  confirmLabel: 'Remove',
                );
                if (confirmed) onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
