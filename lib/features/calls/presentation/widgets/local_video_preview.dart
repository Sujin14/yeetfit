import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Picture-in-picture of the local camera. Tap to switch cameras.
class LocalVideoPreview extends StatelessWidget {
  static const double width = 100;
  static const double height = 140;

  final RTCVideoRenderer renderer;
  final bool isCameraOff;
  final VoidCallback onTap;

  const LocalVideoPreview({
    super.key,
    required this.renderer,
    required this.isCameraOff,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Tooltip(
      message: 'Switch camera',
      child: GestureDetector(
        onTap: isCameraOff ? null : onTap,
        child: Container(
          width: width,
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
              ),
            ],
          ),
          child: isCameraOff
              ? Icon(Icons.videocam_off, color: colors.textSecondary)
              : RTCVideoView(
                  renderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
        ),
      ),
    );
  }
}
