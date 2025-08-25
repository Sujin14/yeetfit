import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chatbot_message_model.dart';


class ChatbotDataSource {
  final GenerativeModel _model;
  final FirebaseFirestore _firestore;

  ChatbotDataSource({
    required String apiKey,
    required FirebaseFirestore firestore,
  })  : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          systemInstruction: Content.system(
            'You are a health and fitness expert named YeetFit Coach. Provide accurate, concise, and helpful answers related to health, fitness, nutrition, and wellness. Avoid medical diagnoses and suggest consulting professionals when appropriate.',
          ),
        ),
        _firestore = firestore;

  Future<ChatbotMessage> sendMessage(String userId, String message) async {
  try {
    final col = _firestore
        .collection('users')
        .doc(userId)
        .collection('chatbot');

    final baseTime = DateTime.now();
    final userMsg = ChatbotMessage(text: message, isUser: true, timestamp: baseTime);
    await col.add(userMsg.toJson());

    final chatSession = _model.startChat();
    final startedAt = DateTime.now();
    final response = await chatSession.sendMessage(Content.text(message));
    final elapsed = DateTime.now().difference(startedAt);
    final remaining = const Duration(seconds: 2) - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    final botTimestamp = baseTime.add(const Duration(microseconds: 1));

    final botMsg = ChatbotMessage(
      text: response.text ?? 'Sorry, I could not process your request.',
      isUser: false,
      timestamp: botTimestamp,
    );

    await col.add(botMsg.toJson());

    return botMsg;
  } catch (e) {
    print('ChatbotDataSource: Error sending message for userId=$userId: $e');
    throw Exception('Failed to send message: $e');
  }
}

  Stream<List<ChatbotMessage>> getMessages(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chatbot')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatbotMessage.fromJson(doc.data())).toList());
  }
}
