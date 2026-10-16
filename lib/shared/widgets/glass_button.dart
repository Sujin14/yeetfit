import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'button_spinner.dart';

/// Secondary action paired with [GradientButton]: frosted fill, thin border.
class GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? textColor;
  final double height;
  final double borderRadius;
  final bool isLoading;

  const GlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.textColor,
    this.height = 52,
    this.borderRadius = 16,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final radius = BorderRadius.circular(borderRadius);
    final foreground = textColor ?? colors.onBackground;
    final enabled = onPressed != null && !isLoading;

    return AnimatedOpacity(
      opacity: onPressed == null ? 0.5 : 1,
      duration: const Duration(milliseconds: 200),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Material(
            color: Colors.white.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: InkWell(
              onTap: enabled ? onPressed : null,
              borderRadius: radius,
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: Center(
                  child: isLoading
                      ? ButtonSpinner(color: foreground)
                      : Text(
                          label,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.copyWith(color: foreground),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
