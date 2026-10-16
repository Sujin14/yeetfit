import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';

/// "7h 30m sleep" preview shown once both times are picked.
class SleepDurationPill extends StatelessWidget {
  final Duration duration;

  const SleepDurationPill({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return Center(
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 16, color: colors.success),
            const SizedBox(width: 6),
            Text(
              '${hours}h ${minutes}m sleep',
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(color: colors.success),
            ),
          ],
        ),
      ),
    );
  }
}
