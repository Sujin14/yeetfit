import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/macro_progress_tile.dart';
import '../providers/food_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Protein, carbs and fat consumed today versus their goals.
class MacroSummaryRow extends ConsumerWidget {
  final String userId;

  const MacroSummaryRow({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final consumed = ref.watch(dailyNutrientsProvider(userId));
    final goals = ref.watch(nutrientGoalsProvider(userId));

    Widget tile(String label, String key, Color color) => Expanded(
      child: GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.all(AppSpacing.smd),
        child: MacroProgressTile(
          label: label,
          consumed: consumed[key] ?? 0,
          goal: goals[key] ?? 0,
          unit: 'g',
          color: color,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Row(
        children: [
          tile('Protein', 'protein', colors.protein),
          const SizedBox(width: AppSpacing.sm),
          tile('Carbs', 'carbs', colors.carbs),
          const SizedBox(width: AppSpacing.sm),
          tile('Fat', 'fat', colors.fat),
        ],
      ),
    );
  }
}
