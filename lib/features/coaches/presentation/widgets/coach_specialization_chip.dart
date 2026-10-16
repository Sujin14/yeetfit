import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';

class CoachSpecializationChip extends StatelessWidget {
  final String label;

  const CoachSpecializationChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GlassCard(
      borderRadius: 10,
      blurStrength: 8,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(fontSize: 12, color: colors.secondary),
      ),
    );
  }
}
