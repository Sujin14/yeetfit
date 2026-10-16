import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';

class PlanCategoryBadge extends StatelessWidget {
  final String label;

  const PlanCategoryBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GlassCard(
      borderRadius: 8,
      blurStrength: 8,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(fontSize: 10, color: colors.secondary),
      ),
    );
  }
}
