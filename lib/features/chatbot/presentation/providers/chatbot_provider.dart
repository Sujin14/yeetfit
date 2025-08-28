import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/chatbot_datasource.dart';
import '../../data/model/chatbot_message_model.dart';
import '../../data/repositories/chatbot_repository.dart';
import '../../domain/usecases/get_chatbot_messages.dart';
import '../../domain/usecases/send_chatbot_messages.dart';
import 'package:flutter/material.dart';

final chatbotDataSourceProvider = Provider(
  (ref) => ChatbotDataSource(
    apiKey: 'AIzaSyDMtQe2Q23Nx6lS7sPC3CZQ2BL6QBrHkvA',
    firestore: FirebaseFirestore.instance,
  ),
);

final chatbotRepositoryProvider = Provider(
  (ref) => ChatbotRepositoryImpl(ref.read(chatbotDataSourceProvider)),
);

final sendChatbotMessageProvider = Provider(
  (ref) => SendChatbotMessage(ref.read(chatbotRepositoryProvider)),
);

final getChatbotMessagesProvider = Provider(
  (ref) => GetChatbotMessages(ref.read(chatbotRepositoryProvider)),
);

final chatbotProvider =
    StateNotifierProvider.family<ChatbotNotifier, AsyncValue<List<ChatbotMessage>>, String>(
  (ref, userId) => ChatbotNotifier(
    ref.read(sendChatbotMessageProvider),
    ref.read(getChatbotMessagesProvider),
    userId,
  ),
);

final chatbotMessagesProvider =
    Provider.family<AsyncValue<List<ChatbotMessage>>, String>((ref, userId) {
  return ref.watch(chatbotProvider(userId));
});

class ChatbotNotifier extends StateNotifier<AsyncValue<List<ChatbotMessage>>> {
  final SendChatbotMessage _sendMessage;
  final GetChatbotMessages _getMessages;
  final String _userId;

  ChatbotNotifier(this._sendMessage, this._getMessages, this._userId)
      : super(const AsyncValue.loading()) {
    _loadMessages();
  }

  void _loadMessages() {
    state = const AsyncValue.loading();
    _getMessages.call(_userId).listen(
          (messages) {
            state = AsyncValue.data(messages);
          },
          onError: (error) {
            state = AsyncValue.error(error, StackTrace.current);
          },
        );
  }

  Future<void> sendMessage(String message) async {
    try {
      final baseTime = DateTime.now();

      final userMessage = ChatbotMessage(
        text: message,
        isUser: true,
        timestamp: baseTime,
      );

      final processingMessage = ChatbotMessage(
        text: 'Processing...',
        isUser: false,
        timestamp: baseTime.add(const Duration(milliseconds: 1)),
      );

      final currentMessages = state.value ?? [];
      state = AsyncValue.data([
        ...currentMessages,
        userMessage,
        processingMessage,
      ]);

      final botResponse = await _sendMessage.call(_userId, message);

      final botMessage = ChatbotMessage(
        text: botResponse.text,
        isUser: false,
        timestamp: baseTime.add(const Duration(milliseconds: 2)),
      );

      final updatedMessages = [
        ...currentMessages,
        userMessage,
        botMessage,
      ];

      state = AsyncValue.data(updatedMessages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  String getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) return 'Today';
    if (msgDate == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void navigateBack(BuildContext context) {
    context.pushReplacement('/user-dashboard');
  }
}