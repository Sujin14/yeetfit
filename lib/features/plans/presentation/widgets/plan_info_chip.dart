import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class PlanInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const PlanInfoChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.secondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: colors.onBackground),
          ),
        ],
      ),
    );
  }
}
