import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// "── or ──" separator between email and social sign-in.
class LoginOptionsDivider extends StatelessWidget {
  const LoginOptionsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final line = Expanded(
      child: Divider(color: colors.textSecondary.withValues(alpha: 0.4)),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smd),
          child: Text(
            'or',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: colors.textSecondary),
          ),
        ),
        line,
      ],
    );
  }
}
