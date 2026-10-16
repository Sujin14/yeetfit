import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class SessionFieldLabel extends StatelessWidget {
  final String text;

  const SessionFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.md),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(color: colors.textSecondary),
      ),
    );
  }
}
