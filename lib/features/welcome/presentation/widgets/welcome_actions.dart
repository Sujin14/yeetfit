import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class WelcomeActions extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  const WelcomeActions({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GradientButton(
            label: 'Get Started',
            height: 56,
            onPressed: onGetStarted,
          ),
          const SizedBox(height: AppSpacing.smd),
          TextButton(
            onPressed: onSignIn,
            child: Text(
              'I already have an account',
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(color: colors.onBackground),
            ),
          ),
        ],
      ),
    );
  }
}
