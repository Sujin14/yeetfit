import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_button.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/yeet_confirm_dialog.dart';
import '../providers/challenge_provider.dart';

class JoinLeaveButton extends ConsumerWidget {
  final String challengeId;
  final String userId;
  final bool isJoined;
  final double width;
  final double height;

  const JoinLeaveButton({
    super.key,
    required this.challengeId,
    required this.userId,
    required this.isJoined,
    this.width = 96,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final provider = challengeMembershipControllerProvider(challengeId);
    final isBusy = ref.watch(provider).isLoading;
    final controller = ref.read(provider.notifier);

    ref.listen(provider, (_, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isJoined
                  ? "Couldn't leave the challenge. Try again."
                  : "Couldn't join the challenge. Try again.",
            ),
          ),
        );
      }
    });

    return SizedBox(
      width: width,
      child: isJoined
          ? GlassButton(
              label: 'Leave',
              textColor: colors.error,
              height: height,
              borderRadius: height / 2,
              isLoading: isBusy,
              onPressed: () async {
                final confirmed = await showYeetConfirmDialog(
                  context,
                  title: 'Leave challenge?',
                  message: 'Your progress will be lost.',
                  confirmLabel: 'Leave',
                );
                if (confirmed) controller.leave(userId);
              },
            )
          : GradientButton(
              label: 'Join',
              height: height,
              borderRadius: height / 2,
              isLoading: isBusy,
              onPressed: () => controller.join(userId),
            ),
    );
  }
}
