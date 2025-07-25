import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasource/firestore_chat_service.dart';
import '../../data/datasource/notification_service.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/use_cases/create_or_get_chat.dart';
import '../../domain/use_cases/delete_chat.dart';
import '../../domain/use_cases/delete_message.dart';
import '../../domain/use_cases/get_chat_messages.dart';
import '../../domain/use_cases/get_message_status.dart';
import '../../domain/use_cases/get_typing_status.dart';
import '../../domain/use_cases/get_user_profile.dart';
import '../../domain/use_cases/send_message.dart';
import '../../domain/use_cases/update_message_status.dart';
import '../../domain/use_cases/update_typing_status.dart';
import '../controllers/chat_controller.dart';


// Payment Providers
final adminIdProvider = FutureProvider<String>((ref) async {
  final doc = await FirebaseFirestore.instance.collection('config').doc('app').get();
  return doc.data()?['adminId'] ?? 'KzWEi9szv2dg9wvEKN6ZEGmZt7L2';
});

final paymentStatusProvider = StreamProvider<bool>((ref) async* {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    yield false;
    return;
  }
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  yield* userDoc.snapshots().map((snapshot) => snapshot.data()?['hasPaid'] ?? false);
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

class PaymentService {
  Future<void> updatePaymentStatus(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'hasPaid': true,
    });
  }
}

// Chat Providers
final chatControllerProvider = StateNotifierProvider.family<ChatController, ChatState, String>((ref, adminId) {
  final getChatMessages = ref.read(getChatMessagesProvider);
  final getMessageStatus = ref.read(getMessageStatusProvider);
  final getUserProfile = ref.read(getUserProfileProvider);
  final sendMessage = ref.read(sendMessageProvider);
  final createOrGetChat = ref.read(createOrGetChatProvider);
  final updateTypingStatus = ref.read(updateTypingStatusProvider);
  final getTypingStatus = ref.read(getTypingStatusProvider);
  final updateMessageStatus = ref.read(updateMessageStatusProvider);
  final deleteChat = ref.read(deleteChatProvider);
  final deleteMessage = ref.read(deleteMessageProvider);

  return ChatController(
    getChatMessages: getChatMessages,
    getMessageStatus: getMessageStatus,
    getUserProfile: getUserProfile,
    sendMessage: sendMessage,
    createOrGetChat: createOrGetChat,
    updateTypingStatus: updateTypingStatus,
    getTypingStatus: getTypingStatus,
    updateMessageStatus: updateMessageStatus,
    deleteChat: deleteChat,
    deleteMessage: deleteMessage,
    adminId: adminId,
  );
});

final getChatMessagesProvider = Provider<GetChatMessages>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return GetChatMessages(repository);
});

final getMessageStatusProvider = Provider<GetMessageStatus>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return GetMessageStatus(repository);
});

final getUserProfileProvider = Provider<GetUserProfile>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return GetUserProfile(repository);
});

final sendMessageProvider = Provider<SendMessage>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return SendMessage(repository);
});

final createOrGetChatProvider = Provider<CreateOrGetChat>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return CreateOrGetChat(repository);
});

final updateTypingStatusProvider = Provider<UpdateTypingStatus>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return UpdateTypingStatus(repository);
});

final getTypingStatusProvider = Provider<GetTypingStatus>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return GetTypingStatus(repository);
});

final updateMessageStatusProvider = Provider<UpdateMessageStatus>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return UpdateMessageStatus(repository);
});

final deleteChatProvider = Provider<DeleteChat>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return DeleteChat(repository);
});

final deleteMessageProvider = Provider<DeleteMessage>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return DeleteMessage(repository);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final service = ref.read(firestoreChatServiceProvider);
  return ChatRepositoryImpl(service);
});

final firestoreChatServiceProvider = Provider<FirestoreChatService>((ref) {
  return FirestoreChatService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});