import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Name and status over the remote video, on a scrim for legibility.
class VideoCallTopBar extends StatelessWidget {
  /// Keeps the text clear of the local preview in the top-right corner.
  static const double _previewClearance = 132;

  final String name;
  final Widget status;

  const VideoCallTopBar({super.key, required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.55),
            Colors.black.withValues(alpha: 0),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.md,
            _previewClearance,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium!.copyWith(color: colors.onPrimary),
              ),
              const SizedBox(height: AppSpacing.xs),
              status,
            ],
          ),
        ),
      ),
    );
  }
}
