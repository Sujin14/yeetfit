import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import '../../domain/entities/training_session.dart';
import 'session_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Horizontal strip of live and upcoming group sessions at the top of
/// Explore. Hidden for members when nothing is scheduled; coaches always see
/// it, with a button to schedule one.
class LiveSessionsSection extends StatelessWidget {
  final AsyncValue<List<TrainingSession>> sessions;
  final DateTime now;
  final Set<String> remindedSessionIds;
  final bool isAdmin;
  final ValueChanged<TrainingSession> onJoin;
  final ValueChanged<TrainingSession> onRemind;
  final ValueChanged<TrainingSession> onDelete;
  final VoidCallback onCreate;

  /// Wraps the section header, e.g. to spotlight it in a tour.
  final Widget Function(Widget header)? headerWrapper;

  const LiveSessionsSection({
    super.key,
    required this.sessions,
    required this.now,
    required this.remindedSessionIds,
    required this.isAdmin,
    required this.onJoin,
    required this.onRemind,
    required this.onDelete,
    required this.onCreate,
    this.headerWrapper,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final items = sessions.value ?? const <TrainingSession>[];
    if (items.isEmpty && !isAdmin) return const SizedBox.shrink();

    final header = Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: SizedBox(
        height: 36,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Live Sessions',
                style: textTheme.titleLarge!.copyWith(
                  color: colors.onBackground,
                ),
              ),
            ),
            if (isAdmin)
              GlassIconButton(
                icon: Icons.edit_calendar_outlined,
                color: colors.onBackground,
                tooltip: 'Schedule session',
                onPressed: onCreate,
              ),
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.smd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerWrapper?.call(header) ?? header,
          const SizedBox(height: 10),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                sessions.isLoading
                    ? 'Loading sessions…'
                    : 'No sessions scheduled. Tap the calendar to add one.',
                style: textTheme.bodyMedium!.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            )
          else
            SizedBox(
              height: SessionCard.height,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final session = items[index];
                  return SessionCard(
                    key: ValueKey(session.id),
                    session: session,
                    now: now,
                    isReminded: remindedSessionIds.contains(session.id),
                    onJoin: () => onJoin(session),
                    onRemind: () => onRemind(session),
                    onLongPress: isAdmin ? () => onDelete(session) : null,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
