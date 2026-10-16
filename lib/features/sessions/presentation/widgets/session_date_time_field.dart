import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Tappable field showing the chosen start date and time.
class SessionDateTimeField extends StatelessWidget {
  final DateTime? value;
  final String? errorText;
  final VoidCallback onTap;

  const SessionDateTimeField({
    super.key,
    required this.value,
    required this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final value = this.value;
    final radius = BorderRadius.circular(14);
    final errorText = this.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: errorText != null
                  ? colors.error
                  : Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.event_outlined,
                    color: colors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.smd),
                  Expanded(
                    child: Text(
                      value == null
                          ? 'Pick date and time'
                          : DateFormat('EEE d MMM yyyy · h:mm a').format(value),
                      style: value == null
                          ? textTheme.bodyMedium!.copyWith(
                              color: colors.textMuted,
                            )
                          : textTheme.bodyLarge!.copyWith(
                              color: colors.onBackground,
                            ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colors.textMuted),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.smd, top: 6),
            child: Text(
              errorText,
              style: textTheme.bodySmall!.copyWith(color: colors.error),
            ),
          ),
      ],
    );
  }
}
