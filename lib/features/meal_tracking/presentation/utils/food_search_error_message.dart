import '../../data/datasources/food_search_datasource.dart';

const _unavailableMessage =
    "Search isn't available right now. Try again in a moment.";

String foodSearchErrorMessage(Object error) => switch (error) {
  FoodSearchException(isRateLimited: true) =>
    'Too many searches — wait a moment and try again.',
  FoodSearchException(:final message) => _readableReason(message),
  _ => _unavailableMessage,
};

/// Server failures arrive as `internal: Food search failed: <reason>`; only
/// the text after the last colon is kept, and raw HTML/JSON bodies are never
/// shown.
String _readableReason(String message) {
  final text = message.trim();
  final reason = text.startsWith('internal:')
      ? text.substring(text.lastIndexOf(':') + 1).trim()
      : text;
  if (reason.isEmpty || reason.contains('<') || reason.contains('{')) {
    return _unavailableMessage;
  }
  return reason;
}
