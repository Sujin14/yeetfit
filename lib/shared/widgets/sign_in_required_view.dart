import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Centered placeholder shown when a screen needs a signed-in user.
class SignInRequiredView extends StatelessWidget {
  final String message;

  const SignInRequiredView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: colors.onBackground),
        ),
      ),
    );
  }
}
