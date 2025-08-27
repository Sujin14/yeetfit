String getFormattedDate(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (messageDate == today) {
    return 'Today';
  } else if (messageDate == yesterday) {
    return 'Yesterday';
  } else {
    // Return format like: 07 Aug 2025
    final day = messageDate.day.toString().padLeft(2, '0');
    final month = _monthAbbreviation(messageDate.month);
    final year = messageDate.year.toString();
    return '$day $month $year';
  }
}

String _monthAbbreviation(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
