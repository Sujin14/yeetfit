import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// "Progress" title row with month navigation and an optional trailing action
/// (metric filter), plus the selected month under the title.
class ProgressHeader extends StatelessWidget {
  final DateTime month;
  final Widget? trailing;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;
  final bool canGoNext;

  const ProgressHeader({
    super.key,
    required this.month,
    this.trailing,
    this.onPreviousMonth,
    this.onNextMonth,
    this.canGoNext = false,
  });

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Progress',
                  style: textTheme.headlineLarge!.copyWith(
                    color: colors.onBackground,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              IconButton(
                onPressed: onPreviousMonth,
                tooltip: 'Previous month',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: colors.onBackground,
                ),
              ),
              Text(
                DateFormat('MMMM yyyy').format(month),
                style: textTheme.bodyMedium!.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              IconButton(
                onPressed: canGoNext ? onNextMonth : null,
                tooltip: 'Next month',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: canGoNext
                      ? colors.onBackground
                      : colors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
