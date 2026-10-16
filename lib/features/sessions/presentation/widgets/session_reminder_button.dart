import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Glass "Remind me" action for upcoming sessions. Disabled once a reminder
/// is set, or when the session starts too soon for one.
class SessionReminderButton extends StatelessWidget {
  static const double height = 30;

  final bool isReminded;
  final bool startsTooSoon;
  final VoidCallback onPressed;

  const SessionReminderButton({
    super.key,
    required this.isReminded,
    required this.startsTooSoon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final (icon, label) = isReminded
        ? (Icons.notifications_active, 'Reminder set')
        : startsTooSoon
        ? (Icons.schedule, 'Starting soon')
        : (Icons.notifications_none, 'Remind me');
    final enabled = !isReminded && !startsTooSoon;
    final color = isReminded ? colors.success : colors.onBackground;
    final radius = BorderRadius.circular(10);

    return Material(
      color: Colors.white.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: enabled ? onPressed : null,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(color: color, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
