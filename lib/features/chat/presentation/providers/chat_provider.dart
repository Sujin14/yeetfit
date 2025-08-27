import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasource/firestore_chat_service.dart';
import '../../data/datasource/notification_service.dart';
import '../../data/model/message_model.dart';
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
import '../../../../shared/widgets/date_util.dart';

final chatControllerProvider =
    StateNotifierProvider.autoDispose.family<ChatController, ChatState, String>((
  ref,
  adminId,
) {
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

// New providers for message list processing
final chatItemsProvider = Provider.family<List<dynamic>, List<MessageModel>>((ref, messages) {
  if (messages.isEmpty) return [];

  final items = <dynamic>[];
  DateTime? lastDate;

  for (var message in messages.reversed) {
    final currentDate = DateTime(
      message.timestamp.year,
      message.timestamp.month,
      message.timestamp.day,
    );
    if (lastDate == null || currentDate != lastDate) {
      items.add(getFormattedDate(message.timestamp));
      lastDate = currentDate;
    }
    items.add(message);
  }

  return items;
});

final isMessageFromCurrentUserProvider = Provider.family<bool, String>((ref, senderId) {
  return senderId == FirebaseAuth.instance.currentUser?.uid;
});