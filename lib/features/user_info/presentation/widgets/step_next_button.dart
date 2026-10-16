import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class StepNextButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const StepNextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: GradientButton(
          label: label,
          isLoading: isLoading,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
