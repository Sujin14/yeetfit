import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Centered icon + message for the idle, empty and error search states.
class FoodSearchMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool isError;

  const FoodSearchMessage({
    super.key,
    required this.icon,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final color = isError ? colors.error : colors.textMuted;
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 48, 40, 24),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: AppSpacing.smd),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isError ? colors.error : colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
