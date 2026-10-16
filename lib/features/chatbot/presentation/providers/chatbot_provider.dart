import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:yeetfit/core/constants/function_regions.dart';
import '../../data/datasources/chatbot_datasource.dart';
import '../../data/model/chatbot_message_model.dart';

final chatbotDataSourceProvider = Provider(
  (ref) => ChatbotDataSource(
    firestore: FirebaseFirestore.instance,
    functions: FirebaseFunctions.instanceFor(region: FunctionRegions.general),
  ),
);

/// Yana conversation: persisted history plus in-flight local bubbles.
/// Disposed with the chatbot screen, which cancels the Firestore listener.
final chatbotProvider = StreamNotifierProvider.autoDispose
    .family<ChatbotNotifier, List<ChatbotMessage>, String>(ChatbotNotifier.new);

class ChatbotNotifier extends StreamNotifier<List<ChatbotMessage>> {
  final String userId;

  List<ChatbotMessage> _stored = const [];
  ChatbotMessage? _pendingUserMessage;
  ChatbotMessage? _transientReply;

  ChatbotNotifier(this.userId);

  @override
  Stream<List<ChatbotMessage>> build() {
    return ref.read(chatbotDataSourceProvider).getMessages(userId).map((
      messages,
    ) {
      _stored = messages;
      return _merged();
    });
  }

  /// Persisted history plus local-only bubbles: the user's message until
  /// Firestore echoes it back, then "Processing..." or a failure notice.
  List<ChatbotMessage> _merged() {
    final pending = _pendingUserMessage;
    final echoed =
        pending != null &&
        _stored.any(
          (m) =>
              m.isUser &&
              m.text == pending.text &&
              !m.timestamp.isBefore(pending.timestamp),
        );
    final reply = _transientReply;
    return [..._stored, if (pending != null && !echoed) pending, ?reply];
  }

  void _publish() => state = AsyncData(_merged());

  Future<void> sendMessage(String message) async {
    final baseTime = DateTime.now();
    _pendingUserMessage = ChatbotMessage(
      text: message,
      isUser: true,
      timestamp: baseTime,
    );
    _transientReply = ChatbotMessage(
      text: 'Processing...',
      isUser: false,
      timestamp: baseTime.add(const Duration(milliseconds: 1)),
    );
    _publish();

    final dataSource = ref.read(chatbotDataSourceProvider);
    try {
      await dataSource.sendMessage(userId, message);
      _transientReply = null;
    } catch (e) {
      debugPrint('Chatbot send failed: $e');
      // Keep the conversation on screen and explain inline instead of
      // replacing the whole chat with an error state.
      _transientReply = ChatbotMessage(
        text: "Couldn't reach Yana. ${_describe(e)}",
        isUser: false,
        timestamp: baseTime.add(const Duration(milliseconds: 2)),
      );
    } finally {
      _pendingUserMessage = null;
    }
    if (ref.mounted) _publish();
  }

  static String _describe(Object error) {
    final text = error.toString().replaceFirst('Exception: ', '');
    return kDebugMode ? text : 'Please try again in a moment.';
  }
}
