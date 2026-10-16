import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../../domain/entities/call_participant.dart';
import 'call_party_avatar.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Large avatar, name and status line: the whole audio call screen, and the
/// placeholder of a video call until the other party's video arrives.
class AudioCallInfo extends StatelessWidget {
  final CallParticipant party;
  final bool isWaiting;
  final Widget status;

  const AudioCallInfo({
    super.key,
    required this.party,
    required this.isWaiting,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CallPartyAvatar(
            name: party.name,
            photoUrl: party.photoUrl,
            pulsing: isWaiting,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            party.name,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.displayMedium!.copyWith(color: colors.onBackground),
          ),
          const SizedBox(height: AppSpacing.sm),
          status,
        ],
      ),
    );
  }
}
