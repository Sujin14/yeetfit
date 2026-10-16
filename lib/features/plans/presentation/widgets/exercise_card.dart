import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/plan_exercise.dart';
import 'exercise_video_sheet.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Compact exercise row; tapping expands description and instructions when
/// the exercise has them.
class ExerciseCard extends StatefulWidget {
  final int index;
  final PlanExercise exercise;

  const ExerciseCard({super.key, required this.index, required this.exercise});

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _expanded = false;

  void _showVideo() {
    final colors = Theme.of(context).extension<AppColors>()!;
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ExerciseVideoSheet(
        title: widget.exercise.name,
        videoUrl: widget.exercise.videoUrl!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final exercise = widget.exercise;
    final detailStyle = textTheme.bodySmall!.copyWith(
      color: colors.textSecondary,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.xs,
      ),
      child: GlassCard(
        borderRadius: 16,
        padding: EdgeInsets.zero,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: exercise.hasDetails
                ? () => setState(() => _expanded = !_expanded)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.smd),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${widget.index + 1}',
                            style: textTheme.bodySmall!.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            exercise.name,
                            style: textTheme.titleMedium!.copyWith(
                              color: colors.onBackground,
                            ),
                          ),
                        ),
                        if (exercise.setsReps.isNotEmpty)
                          Text(
                            exercise.setsReps,
                            textAlign: TextAlign.right,
                            style: detailStyle,
                          ),
                        if (exercise.videoUrl != null)
                          IconButton(
                            onPressed: _showVideo,
                            tooltip: 'Watch video',
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.play_circle_fill_rounded,
                              color: colors.primary,
                            ),
                          ),
                      ],
                    ),
                    if (_expanded) ...[
                      if (exercise.description != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.lg,
                            top: AppSpacing.sm,
                          ),
                          child: Text(
                            exercise.description!,
                            style: detailStyle,
                          ),
                        ),
                      for (final step in exercise.instructions)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.lg,
                            top: AppSpacing.xs,
                          ),
                          child: Text('• $step', style: detailStyle),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
