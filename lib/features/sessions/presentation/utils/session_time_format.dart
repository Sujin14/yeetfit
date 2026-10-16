import 'package:intl/intl.dart';

/// "Today, 6:00 PM", "Tomorrow, 9:30 AM" or "Sat 12 Oct, 7:00 PM".
String formatSessionSchedule(DateTime scheduledAt, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day);
  final time = DateFormat.jm().format(scheduledAt);
  return switch (day.difference(today).inDays) {
    0 => 'Today, $time',
    1 => 'Tomorrow, $time',
    _ => '${DateFormat('EEE d MMM').format(scheduledAt)}, $time',
  };
}

/// Countdown to a session start: "in 45m", "in 2h", "in 3d".
String formatStartsIn(DateTime scheduledAt, DateTime now) {
  final remaining = scheduledAt.difference(now);
  if (remaining.inMinutes < 1) return 'starting';
  if (remaining.inHours < 1) return 'in ${remaining.inMinutes}m';
  if (remaining.inDays < 1) return 'in ${remaining.inHours}h';
  return 'in ${remaining.inDays}d';
}
