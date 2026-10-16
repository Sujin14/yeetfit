import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Tappable row in the sleep entry sheet showing one picked time.
class SleepTimePickerRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final DateTime? time;
  final VoidCallback onTap;

  const SleepTimePickerRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: GlassCard(
        borderRadius: 18,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: AppSpacing.smd),
            Text(
              label,
              style: textTheme.titleMedium!.copyWith(
                color: colors.onBackground,
              ),
            ),
            const Spacer(),
            Text(
              time == null ? '--:--' : DateFormat('h:mm a').format(time!),
              style: textTheme.headlineMedium!.copyWith(
                color: time == null ? colors.textMuted : colors.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
