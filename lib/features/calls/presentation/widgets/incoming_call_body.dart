import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../../domain/entities/call_session.dart';
import 'call_action_button.dart';
import 'call_party_avatar.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class IncomingCallBody extends StatelessWidget {
  final CallSession call;
  final bool isBusy;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const IncomingCallBody({
    super.key,
    required this.call,
    required this.isBusy,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final caller = call.caller;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          children: [
            const Spacer(),
            CallPartyAvatar(
              name: caller.name,
              photoUrl: caller.photoUrl,
              pulsing: true,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              caller.name,
              textAlign: TextAlign.center,
              style: textTheme.displayMedium!.copyWith(
                color: colors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Incoming ${call.type.isVideo ? 'video' : 'audio'} call...',
              style: textTheme.bodyLarge!.copyWith(color: colors.textSecondary),
            ),
            const Spacer(flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CallActionButton(
                  icon: Icons.call_end,
                  label: 'Decline',
                  color: colors.error,
                  onPressed: isBusy ? null : onDecline,
                ),
                CallActionButton(
                  icon: call.type.isVideo ? Icons.videocam : Icons.call,
                  label: 'Accept',
                  color: colors.success,
                  isLoading: isBusy,
                  onPressed: onAccept,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
