import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/button_spinner.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/yeet_confirm_dialog.dart';
import '../../domain/entities/coach.dart';
import '../providers/coach_provider.dart';
import 'coach_avatar.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// The client's current coach with a menu to remove them. Renders nothing
/// when no coach is assigned, but stays in the tree so the removal can
/// finish and report back after the coach disappears.
class MyCoachCard extends ConsumerWidget {
  final String clientUid;
  final ValueChanged<Coach> onOpen;
  final VoidCallback onRemoved;

  const MyCoachCard({
    super.key,
    required this.clientUid,
    required this.onOpen,
    required this.onRemoved,
  });

  Future<void> _remove(BuildContext context, WidgetRef ref, Coach coach) async {
    final controller = ref.read(coachRemovalControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final coachName = coach.name.isEmpty ? 'this coach' : coach.name;
    final confirmed = await showYeetConfirmDialog(
      context,
      title: 'Remove Coach',
      message:
          'Are you sure you want to remove $coachName as your coach? '
          'You can find a new coach anytime.',
      confirmLabel: 'Remove Coach',
    );
    if (!confirmed) return;

    final error = await controller.remove();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            error ??
                'Coach removed. You can find a new coach in the Coaches tab.',
          ),
        ),
      );
    if (error == null) onRemoved();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coach = ref.watch(currentCoachProvider(clientUid)).value;
    final isRemoving = ref.watch(coachRemovalControllerProvider).isLoading;
    if (coach == null && !isRemoving) return const SizedBox.shrink();

    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.md,
        AppSpacing.screenEdge,
        0,
      ),
      child: GlassCard(
        borderRadius: 20,
        padding: EdgeInsets.zero,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: coach == null || isRemoving ? null : () => onOpen(coach),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.smd,
                AppSpacing.xs,
                AppSpacing.smd,
              ),
              child: Row(
                children: [
                  CoachAvatar(
                    imageUrl: coach?.profileImageUrl,
                    name: coach?.name ?? '',
                    radius: 24,
                  ),
                  const SizedBox(width: AppSpacing.smd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Coach',
                          style: textTheme.bodySmall!.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        Text(
                          coach == null ? 'Removing your coach…' : coach.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium!.copyWith(
                            color: colors.onBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isRemoving)
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: ButtonSpinner(color: colors.onBackground),
                    )
                  else
                    PopupMenuButton<void>(
                      tooltip: 'Coach options',
                      icon: Icon(Icons.more_vert, color: colors.textSecondary),
                      color: colors.surface,
                      itemBuilder: (_) => [
                        PopupMenuItem<void>(
                          onTap: () => _remove(context, ref, coach!),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_remove_outlined,
                                color: colors.error,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Remove Coach',
                                style: textTheme.bodyMedium!.copyWith(
                                  color: colors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
