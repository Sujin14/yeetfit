import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import '../model/chatbot_message_model.dart';

class ChatbotDataSource {
  static const _geminiFunction = 'callGemini';
  static const _fallbackReply = "Sorry, I couldn't process that.";

  /// Tells `callGemini` to answer as Yana; the persona lives server-side.
  static const _coachMode = 'coach';

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  ChatbotDataSource({
    required FirebaseFirestore firestore,
    required FirebaseFunctions functions,
  }) : _firestore = firestore,
       _functions = functions;

  Future<String> _generateReply(String message) async {
    try {
      final result = await _functions
          .httpsCallable(_geminiFunction)
          .call<Map<String, dynamic>>({'prompt': message, 'mode': _coachMode});
      final text = (result.data['text'] as String?)?.trim();
      return (text == null || text.isEmpty) ? _fallbackReply : text;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('Functions error: ${e.code} — ${e.message} — ${e.details}');
      throw Exception('Failed to send message: ${e.message}');
    }
  }

  Future<ChatbotMessage> sendMessage(String userId, String message) async {
    try {
      final col = _firestore
          .collection('users')
          .doc(userId)
          .collection('chatbot');

      final baseTime = DateTime.now();

      // Save user message
      await col.add(
        ChatbotMessage(
          text: message,
          isUser: true,
          timestamp: baseTime,
        ).toJson(),
      );

      final startedAt = DateTime.now();

      final botText = await _generateReply(message);

      // 2-second minimum delay to support UI typing animation
      final elapsed = DateTime.now().difference(startedAt);
      final remaining = const Duration(seconds: 2) - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }

      final botMsg = ChatbotMessage(
        text: botText,
        isUser: false,
        timestamp: baseTime.add(const Duration(microseconds: 1)),
      );

      // Save bot message
      await col.add(botMsg.toJson());

      return botMsg;
    } on FirebaseException catch (e, stack) {
      debugPrint(
        'ChatbotDataSource Firestore error: ${e.code} — ${e.message}\n$stack',
      );
      throw Exception('Failed to send message: ${e.message}');
    }
  }

  Stream<List<ChatbotMessage>> getMessages(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chatbot')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ChatbotMessage.fromJson(doc.data()))
              .toList(),
        );
  }
}
