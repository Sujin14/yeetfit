import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// "Question? Action" line used to switch between login and sign-up.
class AuthRedirectPrompt extends StatelessWidget {
  final String message;
  final String actionLabel;
  final VoidCallback onPressed;

  const AuthRedirectPrompt({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              actionLabel,
              style: textTheme.labelLarge!.copyWith(
                color: colors.onBackground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
