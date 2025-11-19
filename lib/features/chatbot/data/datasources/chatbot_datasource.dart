import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleai_dart/googleai_dart.dart';
import '../model/chatbot_message_model.dart';

class ChatbotDataSource {
  final GoogleAIClient _client;
  final FirebaseFirestore _firestore;

  ChatbotDataSource({
    required String apiKey,
    required FirebaseFirestore firestore,
  }) : _client = GoogleAIClient(
          config: GoogleAIConfig.googleAI(
            authProvider: ApiKeyProvider(apiKey),
          ),
        ),
        _firestore = firestore;

  // Extract bot response text
  String _extractText(GenerateContentResponse res) {
    try {
      final candidate = res.candidates?.first;
      final parts = candidate?.content?.parts;
      if (parts == null) return "Sorry, I couldn't process that.";
      final text = parts.whereType<TextPart>().map((e) => e.text).join(" ");
      return text.isNotEmpty ? text : "Sorry, I couldn't process that.";
    } catch (_) {
      return "Sorry, I couldn't process that.";
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

      // SYSTEM PROMPT (inside user message - required for v1beta)
      final systemPrompt =
          "You are a health & fitness expert named YeetFit Coach. "
          "You ONLY answer questions strictly related to fitness, workouts, exercises, diet, nutrition, "
          "fat loss, muscle building, supplements, and recovery. "
          "If a user asks about anything not related to fitness, politely decline and redirect them back "
          "to fitness topics.\n\n"
          "User Message: $message";

      // Send Gemini Request (NO system role - fully compatible)
      final response = await _client.models.generateContent(
        model: 'gemini-2.0-flash',
        request: GenerateContentRequest(
          contents: [
            Content(
              role: 'user',
              parts: [TextPart(systemPrompt)],
            ),
          ],
        ),
      );

      final botText = _extractText(response);

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
    } catch (e, stack) {
      print("ChatbotDataSource error: $e");
      print(stack);
      throw Exception("Failed to send message");
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
