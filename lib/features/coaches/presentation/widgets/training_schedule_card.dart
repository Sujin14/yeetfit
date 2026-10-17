import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/chat_route_constants.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';

const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Read-only weekday chips for the client's training days with this coach.
class TrainingScheduleCard extends StatelessWidget {
  final List<int> trainingDays;
  final String? coachId;

  const TrainingScheduleCard({
    super.key,
    required this.trainingDays,
    this.coachId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Training Schedule',
              style: textTheme.titleMedium!.copyWith(
                color: colors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.smd),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (var day = 1; day <= _dayLabels.length; day++)
                  FilterChip(
                    label: Text(_dayLabels[day - 1]),
                    selected: trainingDays.contains(day),
                    onSelected: null,
                    showCheckmark: false,
                    selectedColor: colors.secondary,
                    disabledColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    side: BorderSide(
                      color: trainingDays.contains(day)
                          ? colors.secondary
                          : colors.divider,
                    ),
                    labelStyle: TextStyle(
                      color: trainingDays.contains(day)
                          ? colors.onPrimary
                          : colors.subtle,
                      fontWeight: trainingDays.contains(day)
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
              ],
            ),
            if (trainingDays.isEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Your coach hasn't set a schedule yet",
                style: textTheme.bodyMedium!.copyWith(color: colors.subtle),
              ),
            ],
            if (coachId != null) ...[
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => context.push(
                    ChatRouteConstants.chat,
                    extra: coachId,
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Message coach about schedule'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
