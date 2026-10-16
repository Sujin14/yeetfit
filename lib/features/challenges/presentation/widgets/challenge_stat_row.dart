import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class ChallengeStatRow extends StatelessWidget {
  final String label;
  final String value;

  const ChallengeStatRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium!.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.titleMedium!.copyWith(color: colors.onBackground),
          ),
        ],
      ),
    );
  }
}
