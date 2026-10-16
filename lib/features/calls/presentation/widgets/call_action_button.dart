import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/button_spinner.dart';

/// Large round accept/decline button with a caption, for the incoming call
/// screen.
class CallActionButton extends StatelessWidget {
  static const double _size = 72;

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CallActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color,
          shape: const CircleBorder(),
          elevation: 6,
          shadowColor: color.withValues(alpha: 0.5),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: isLoading ? null : onPressed,
            child: SizedBox.square(
              dimension: _size,
              child: Center(
                child: isLoading
                    ? ButtonSpinner(color: colors.onPrimary)
                    : Icon(icon, color: colors.onPrimary, size: 32),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.copyWith(color: colors.onBackground),
        ),
      ],
    );
  }
}
