import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// "Progress" title with the current month underneath.
class ProgressHeader extends StatelessWidget {
  final DateTime month;

  const ProgressHeader({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.smd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress',
            style: textTheme.headlineLarge!.copyWith(
              color: colors.onBackground,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('MMMM yyyy').format(month),
            style: textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
