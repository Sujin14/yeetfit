/// Form validator: accepts https://meet.google.com/... links only.
String? validateMeetLink(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Add the Google Meet link';
  final uri = Uri.tryParse(text);
  final isMeetLink =
      uri != null &&
      uri.scheme == 'https' &&
      uri.host == 'meet.google.com' &&
      uri.pathSegments.any((segment) => segment.isNotEmpty);
  return isMeetLink
      ? null
      : 'Use a link like https://meet.google.com/abc-defg-hij';
}
