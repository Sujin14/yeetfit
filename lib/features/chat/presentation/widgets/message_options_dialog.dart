import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class MessageOptionsDialog extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  const MessageOptionsDialog({
    super.key,
    required this.onCopy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Message Options',
        style: textTheme.titleLarge!.copyWith(color: colors.onSurface),
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.copy_rounded, color: colors.textSecondary),
            title: Text(
              'Copy',
              style: textTheme.bodyLarge!.copyWith(color: colors.onSurface),
            ),
            onTap: onCopy,
          ),
          ListTile(
            leading: Icon(Icons.delete_outline_rounded, color: colors.error),
            title: Text(
              'Delete',
              style: textTheme.bodyLarge!.copyWith(color: colors.error),
            ),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
