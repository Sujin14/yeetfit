import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;
  const YoutubePlayerWidget({super.key, required this.videoUrl});

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    // Strip extra query parameters
    final videoUrl = widget.videoUrl.split('?').first;

    final videoId = YoutubePlayerController.convertUrlToId(videoUrl);

    if (videoId != null) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Text(
        'Invalid video URL',
        style: AppTheme.textStyles['body']?.copyWith(
          color: AppTheme.colors['error'],
          fontSize: FixedSizes.font14(context),
        ),
      );
    }

    return SizedBox(
      height: FixedSizes.box200(context),
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.colors['primaryBorder']!,
            width: FixedSizes.box5(context),
          ),
          borderRadius:
              BorderRadius.circular(FixedSizes.borderRadius(context)),
        ),
        child: YoutubePlayer(
          controller: _controller!,
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}
