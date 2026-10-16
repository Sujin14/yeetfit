import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/drag_handle.dart';
import 'youtube_player_widget.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Bottom sheet hosting the existing [YoutubePlayerWidget] for one exercise.
class ExerciseVideoSheet extends StatelessWidget {
  final String title;
  final String videoUrl;

  const ExerciseVideoSheet({
    super.key,
    required this.title,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragHandle(),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: colors.onSurface),
            ),
            const SizedBox(height: AppSpacing.smd),
            YoutubePlayerWidget(videoUrl: videoUrl),
          ],
        ),
      ),
    );
  }
}
