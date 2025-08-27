

import '../../data/model/message_model.dart';
import '../repositories/chat_repository.dart';

class GetMessageStatus {
  final ChatRepository repository;

  GetMessageStatus(this.repository);

  Stream<MessageModel> call(String chatId, String messageId) {
    return repository.getMessageStatus(chatId, messageId);
  }
}