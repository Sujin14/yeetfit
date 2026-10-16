import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Replaces the message composer once the other user's account is gone.
class ChatAccountDeletedNotice extends StatelessWidget {
  const ChatAccountDeletedNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.smd,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Text(
          'This user has deleted their account. '
          "You can view past messages but can't send new ones.",
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
        ),
      ),
    );
  }
}
