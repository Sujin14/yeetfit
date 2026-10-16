import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../data/models/plan_model.dart';
import '../utils/plan_display.dart';
import 'plan_info_chip.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class PlanInfoSection extends StatelessWidget {
  final PlanModel plan;

  const PlanInfoSection({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final macros = plan.totalMacronutrients;
    final description = plan.description;

    final chips = <Widget>[
      if (plan.duration != null)
        PlanInfoChip(icon: Icons.schedule_rounded, label: plan.duration!),
      if (plan.difficulty != null)
        PlanInfoChip(icon: Icons.speed_rounded, label: plan.difficulty!),
      PlanInfoChip(icon: plan.categoryIcon, label: plan.categoryLabel),
      if (plan.isDiet) ...[
        PlanInfoChip(
          icon: Icons.local_fire_department_rounded,
          label: '${plan.totalCalories} kcal',
        ),
        PlanInfoChip(
          icon: Icons.egg_alt_outlined,
          label: 'P ${macros['protein']?.toStringAsFixed(0) ?? 0}g',
        ),
        PlanInfoChip(
          icon: Icons.grain_rounded,
          label: 'C ${macros['carbs']?.toStringAsFixed(0) ?? 0}g',
        ),
        PlanInfoChip(
          icon: Icons.water_drop_outlined,
          label: 'F ${macros['fats']?.toStringAsFixed(0) ?? 0}g',
        ),
      ] else
        PlanInfoChip(
          icon: Icons.format_list_numbered_rounded,
          label: '${plan.exercises.length} exercises',
        ),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: chips,
            ),
            if (description != null) ...[
              const SizedBox(height: 14),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
