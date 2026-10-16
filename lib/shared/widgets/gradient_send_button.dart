import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class GradientSendButton extends StatelessWidget {
  static const double _size = 44;

  final VoidCallback? onPressed;

  const GradientSendButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Tooltip(
      message: 'Send',
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.secondary],
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: _size,
              child: Icon(
                Icons.send_rounded,
                size: 20,
                color: colors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
