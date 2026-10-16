import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerWidget({super.key, required this.videoUrl});

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  // Created once; building it in build() leaked a web player per rebuild.
  late final String? _videoId = YoutubePlayerController.convertUrlToId(
    widget.videoUrl,
  );
  late final YoutubePlayerController? _controller = _videoId == null
      ? null
      : YoutubePlayerController.fromVideoId(
          videoId: _videoId,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
          ),
        );

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final controller = _controller;
    if (controller == null) {
      return Text(
        'Invalid video URL',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: colors.error, fontSize: 14),
      );
    }
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: YoutubePlayer(controller: controller),
      ),
    );
  }
}
