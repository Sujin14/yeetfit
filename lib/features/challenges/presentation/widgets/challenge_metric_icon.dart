import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../utils/challenge_metric_style.dart';

class ChallengeMetricIcon extends StatelessWidget {
  final String metric;
  final double size;

  const ChallengeMetricIcon({super.key, required this.metric, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final color = challengeMetricColor(metric, colors);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.18),
      ),
      child: Icon(challengeMetricIcon(metric), size: size * 0.55, color: color),
    );
  }
}
