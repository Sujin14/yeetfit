import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../../domain/entities/call_type.dart';
import 'call_control_button.dart';

/// Mute, end call, and camera (video) or speaker (audio) toggle.
class CallControlsBar extends StatelessWidget {
  final CallType type;
  final bool isMuted;
  final bool isCameraOff;
  final bool isSpeakerOn;
  final VoidCallback onToggleMute;
  final VoidCallback onEnd;
  final VoidCallback onToggleCamera;
  final VoidCallback onToggleSpeaker;

  const CallControlsBar({
    super.key,
    required this.type,
    required this.isMuted,
    required this.isCameraOff,
    required this.isSpeakerOn,
    required this.onToggleMute,
    required this.onEnd,
    required this.onToggleCamera,
    required this.onToggleSpeaker,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CallControlButton(
          icon: isMuted ? Icons.mic_off : Icons.mic,
          tooltip: isMuted ? 'Unmute' : 'Mute',
          isActive: isMuted,
          onPressed: onToggleMute,
        ),
        CallControlButton(
          icon: Icons.call_end,
          tooltip: 'End call',
          size: 72,
          backgroundColor: colors.error,
          onPressed: onEnd,
        ),
        if (type.isVideo)
          CallControlButton(
            icon: isCameraOff ? Icons.videocam_off : Icons.videocam,
            tooltip: isCameraOff ? 'Turn camera on' : 'Turn camera off',
            isActive: isCameraOff,
            onPressed: onToggleCamera,
          )
        else
          CallControlButton(
            icon: isSpeakerOn ? Icons.volume_up : Icons.hearing,
            tooltip: isSpeakerOn ? 'Use earpiece' : 'Use speaker',
            isActive: isSpeakerOn,
            onPressed: onToggleSpeaker,
          ),
      ],
    );
  }
}
