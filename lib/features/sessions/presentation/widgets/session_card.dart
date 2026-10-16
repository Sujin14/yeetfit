import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/services/notification_service.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import '../../domain/entities/training_session.dart';
import '../utils/session_time_format.dart';
import 'session_reminder_button.dart';
import 'session_status_chip.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class SessionCard extends StatelessWidget {
  static const double width = 240;
  static const double height = 140;

  final TrainingSession session;
  final DateTime now;
  final bool isReminded;
  final VoidCallback onJoin;
  final VoidCallback onRemind;

  /// Coaches only: long-press to delete.
  final VoidCallback? onLongPress;

  const SessionCard({
    super.key,
    required this.session,
    required this.now,
    required this.isReminded,
    required this.onJoin,
    required this.onRemind,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final isLive = session.isLiveAt(now);
    final trainer = session.trainerName;
    final startsTooSoon = !session.scheduledAt
        .subtract(NotificationService.sessionReminderLeadTime)
        .isAfter(now);

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: AppSpacing.smd),
        child: GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.smd,
            AppSpacing.smd,
            AppSpacing.smd,
            10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: colors.primary.withValues(alpha: 0.3),
                    foregroundImage: session.trainerPhoto.isNotEmpty
                        ? CachedNetworkImageProvider(session.trainerPhoto)
                        : null,
                    child: Text(
                      trainer.isNotEmpty ? trainer[0].toUpperCase() : '?',
                      style: textTheme.bodySmall!.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trainer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall!.copyWith(
                            color: colors.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${formatSessionSchedule(session.scheduledAt, now)}'
                          ' · ${session.durationMinutes} min',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall!.copyWith(
                            color: colors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  SessionStatusChip(session: session, now: now),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: Text(
                  session.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium!.copyWith(
                    color: colors.onBackground,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
              if (isLive)
                GradientButton(
                  label: 'Join',
                  height: SessionReminderButton.height,
                  borderRadius: 10,
                  trailingIcon: Icons.videocam_rounded,
                  onPressed: onJoin,
                )
              else
                SessionReminderButton(
                  isReminded: isReminded,
                  startsTooSoon: startsTooSoon,
                  onPressed: onRemind,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
