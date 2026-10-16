import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// The other party's camera, filling the screen.
class RemoteVideoView extends StatelessWidget {
  final RTCVideoRenderer renderer;

  const RemoteVideoView({super.key, required this.renderer});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ColoredBox(
      color: colors.background,
      child: RTCVideoView(
        renderer,
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      ),
    );
  }
}
