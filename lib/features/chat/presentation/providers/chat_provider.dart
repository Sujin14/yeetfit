import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasource/firestore_chat_service.dart';
import '../../data/datasource/message_delivery_service.dart';
import '../controllers/chat_controller.dart';

final firestoreChatServiceProvider = Provider<FirestoreChatService>((ref) {
  return FirestoreChatService();
});

final chatControllerProvider = NotifierProvider.autoDispose
    .family<ChatController, ChatState, String>(ChatController.new);

final messageDeliveryServiceProvider = Provider<MessageDeliveryService>((ref) {
  final service = MessageDeliveryService();
  ref.onDispose(service.stop);
  return service;
});
