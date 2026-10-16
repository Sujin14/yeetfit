import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Confirms deleting the whole conversation. Pops `true` when confirmed.
class ChatDeleteDialog extends StatelessWidget {
  const ChatDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Delete Chat',
        style: textTheme.titleLarge!.copyWith(color: colors.onSurface),
      ),
      content: Text(
        'Are you sure you want to delete the entire chat?',
        style: textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: textTheme.labelLarge!.copyWith(color: colors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Delete',
            style: textTheme.labelLarge!.copyWith(color: colors.error),
          ),
        ),
      ],
    );
  }
}
