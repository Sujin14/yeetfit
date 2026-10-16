import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Asks the user to confirm a destructive action. Resolves to `true` only
/// when the confirm button is tapped; dismissing counts as cancel.
Future<bool> showYeetConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  Color? confirmColor,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (_) => YeetConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      confirmColor: confirmColor,
    ),
  );
  return confirmed ?? false;
}

class YeetConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final Color? confirmColor;

  const YeetConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final accent = confirmColor ?? colors.error;

    Widget button({
      required String label,
      required Color textColor,
      required BoxDecoration decoration,
      required bool result,
    }) {
      return Expanded(
        child: DecoratedBox(
          decoration: decoration,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.of(context).pop(result),
              child: SizedBox(
                height: 48,
                child: Center(
                  child: Text(
                    label,
                    style: textTheme.labelLarge!.copyWith(color: textColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(AppSpacing.lg),
        color: colors.surface,
        opacity: 0.9,
        blurStrength: 30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleLarge!.copyWith(color: colors.onBackground),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: textTheme.bodyMedium!.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                button(
                  label: 'Cancel',
                  textColor: colors.onBackground,
                  result: false,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.smd),
                button(
                  label: confirmLabel,
                  textColor: colors.onPrimary,
                  result: true,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [accent, accent.withValues(alpha: 0.75)],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
