import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import '../../domain/entities/call_session.dart';
import '../providers/active_call_state.dart';
import 'audio_call_info.dart';
import 'call_controls_bar.dart';
import 'call_status_text.dart';
import 'local_video_preview.dart';
import 'remote_video_view.dart';
import 'video_call_top_bar.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ActiveCallBody extends StatelessWidget {
  final CallSession call;
  final String userId;
  final ActiveCallState state;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  final VoidCallback onToggleMute;
  final VoidCallback onEnd;
  final VoidCallback onToggleCamera;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onSwitchCamera;

  const ActiveCallBody({
    super.key,
    required this.call,
    required this.userId,
    required this.state,
    required this.localRenderer,
    required this.remoteRenderer,
    required this.onToggleMute,
    required this.onEnd,
    required this.onToggleCamera,
    required this.onToggleSpeaker,
    required this.onSwitchCamera,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final party = call.otherParty(userId);
    final isVideo = call.type.isVideo;
    final showRemoteVideo = isVideo && state.hasRemoteStream;

    Widget status(Color color) => CallStatusText(
      phase: state.phase,
      status: call.status,
      isCaller: call.isCaller(userId),
      otherPartyName: party.name,
      startedAt: call.startedAt,
      error: state.error,
      style: textTheme.bodyLarge!.copyWith(color: color),
    );

    return ShellGradientBackground(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (showRemoteVideo) ...[
            RemoteVideoView(renderer: remoteRenderer),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: VideoCallTopBar(
                name: party.name,
                status: status(colors.onPrimary.withValues(alpha: 0.85)),
              ),
            ),
          ] else
            Center(
              child: AudioCallInfo(
                party: party,
                isWaiting:
                    state.phase == CallConnectionPhase.connecting ||
                    state.phase == CallConnectionPhase.waiting,
                status: status(
                  state.phase == CallConnectionPhase.failed
                      ? colors.error
                      : colors.textSecondary,
                ),
              ),
            ),
          if (isVideo)
            Positioned(
              top: 60,
              right: 16,
              child: LocalVideoPreview(
                renderer: localRenderer,
                isCameraOff: state.isCameraOff,
                onTap: onSwitchCamera,
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                child: CallControlsBar(
                  type: call.type,
                  isMuted: state.isMuted,
                  isCameraOff: state.isCameraOff,
                  isSpeakerOn: state.isSpeakerOn,
                  onToggleMute: onToggleMute,
                  onEnd: onEnd,
                  onToggleCamera: onToggleCamera,
                  onToggleSpeaker: onToggleSpeaker,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
