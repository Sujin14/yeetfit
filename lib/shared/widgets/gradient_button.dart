import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'button_spinner.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Full-width primary → secondary gradient call-to-action.
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;
  final bool isLoading;
  final IconData? trailingIcon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
    this.borderRadius = 16,
    this.isLoading = false,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final radius = BorderRadius.circular(borderRadius);
    final enabled = onPressed != null && !isLoading;

    return AnimatedOpacity(
      opacity: onPressed == null ? 0.5 : 1,
      duration: const Duration(milliseconds: 200),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.secondary],
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: radius,
            child: SizedBox(
              height: height,
              width: double.infinity,
              child: Center(
                child: isLoading
                    ? ButtonSpinner(color: colors.onPrimary)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(color: colors.onPrimary),
                          ),
                          if (trailingIcon != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Icon(
                              trailingIcon,
                              size: 20,
                              color: colors.onPrimary,
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
