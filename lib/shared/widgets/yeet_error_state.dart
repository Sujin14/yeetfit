import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'glass_card.dart';
import 'gradient_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Error state with an optional retry. The default form is a centred glass
/// card for screens and sections; [YeetErrorState.compact] drops the card
/// and shrinks everything to fit inside an existing card (e.g. a chart area).
class YeetErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool compact;

  const YeetErrorState({super.key, required this.message, this.onRetry})
    : compact = false;

  const YeetErrorState.compact({super.key, required this.message, this.onRetry})
    : compact = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.wifi_off_rounded,
          size: compact ? 28 : 48,
          color: colors.textMuted,
        ),
        SizedBox(height: compact ? 8 : 16),
        Text(
          'Something went wrong',
          style: (compact ? textTheme.bodyMedium : textTheme.titleMedium)!
              .copyWith(color: colors.onBackground),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: compact ? 4 : 8),
        Text(
          message,
          maxLines: compact ? 2 : 6,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall!.copyWith(color: colors.textSecondary),
          textAlign: TextAlign.center,
        ),
        if (onRetry != null) ...[
          SizedBox(height: compact ? 12 : 20),
          compact
              ? SizedBox(
                  width: 140,
                  child: GradientButton(
                    label: 'Try again',
                    onPressed: onRetry,
                    height: 36,
                    borderRadius: 18,
                  ),
                )
              : GradientButton(
                  label: 'Try again',
                  onPressed: onRetry,
                  height: 44,
                ),
        ],
      ],
    );

    if (compact) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.smd),
          child: content,
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: content,
        ),
      ),
    );
  }
}
