import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class ChallengeProgressBar extends StatelessWidget {
  final double current;
  final double goal;
  final double height;

  const ChallengeProgressBar({
    super.key,
    required this.current,
    required this.goal,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: height,
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        valueColor: AlwaysStoppedAnimation(colors.primary),
      ),
    );
  }
}
