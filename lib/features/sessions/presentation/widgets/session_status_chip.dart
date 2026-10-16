import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../../domain/entities/training_session.dart';
import '../utils/session_time_format.dart';

/// "🔴 Live" while the session runs, otherwise a countdown like "in 2h".
class SessionStatusChip extends StatelessWidget {
  final TrainingSession session;
  final DateTime now;

  const SessionStatusChip({
    super.key,
    required this.session,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isLive = session.isLiveAt(now);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isLive
            ? colors.error.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isLive
              ? colors.error.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        isLive ? '🔴 Live' : formatStartsIn(session.scheduledAt, now),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: isLive ? colors.onBackground : colors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
