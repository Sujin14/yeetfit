import 'package:intl/intl.dart';

String getFormattedDate(DateTime date) {
  final today = DateTime.now();
  final yesterday = today.subtract(const Duration(days: 1));

  if (date.year == today.year && date.month == today.month && date.day == today.day) {
    return 'Today';
  } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
    return 'Yesterday';
  } else {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}