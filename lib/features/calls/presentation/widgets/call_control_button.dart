import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Round in-call control. Glass by default; [backgroundColor] gives a solid
/// fill (the red end-call button), [isActive] highlights a toggled state.
class CallControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;
  final bool isActive;
  final Color? backgroundColor;

  const CallControlButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.size = 56,
    this.isActive = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final solid = backgroundColor;
    final fill =
        solid ??
        (isActive
            ? colors.onPrimary.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.15));
    final iconColor = solid != null || !isActive
        ? colors.onPrimary
        : colors.gradientStart;

    return Tooltip(
      message: tooltip,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Material(
            color: fill,
            shape: CircleBorder(
              side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: SizedBox.square(
                dimension: size,
                child: Icon(icon, color: iconColor, size: size * 0.45),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
