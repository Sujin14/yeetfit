import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../shared/theme/theme.dart';

class YoutubePlayerWidget extends StatelessWidget {
  final String videoUrl;

  const YoutubePlayerWidget({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayerController.convertUrlToId(videoUrl);
    if (videoId == null) {
      return Text(
        'Invalid video URL',
        style:
            AppTheme.textStyles['body']?.copyWith(
              color: AppTheme.colors['error'] ?? Colors.red,
              fontSize: 14.sp,
            ) ??
            TextStyle(fontSize: 14.sp, color: Colors.red),
      );
    }
    return SizedBox(
      height: 200.h,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.colors['primaryBorder'] ?? Colors.grey,
            width: 5.w,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: YoutubePlayer(
          controller: YoutubePlayerController.fromVideoId(
            videoId: videoId,
            autoPlay: false,
            params: const YoutubePlayerParams(
              showControls: true,
              showFullscreenButton: true,
            ),
          ),
        ),
      ),
    );
  }
}
