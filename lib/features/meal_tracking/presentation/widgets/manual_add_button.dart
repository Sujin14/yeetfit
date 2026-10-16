import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Gradient FAB that opens manual food entry.
class ManualAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ManualAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Tooltip(
      message: 'Add food manually',
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.secondary],
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox.square(
              dimension: 56,
              child: Icon(Icons.edit_note_rounded, color: colors.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
