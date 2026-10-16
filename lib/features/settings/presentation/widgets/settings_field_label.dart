import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Caption above a form field; the glass fields have no floating label, so
/// pre-filled values would otherwise be unlabelled.
class SettingsFieldLabel extends StatelessWidget {
  final String text;

  const SettingsFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: colors.textSecondary),
      ),
    );
  }
}
