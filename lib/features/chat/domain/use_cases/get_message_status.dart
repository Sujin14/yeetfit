import '../../data/model/message_model.dart';
import '../repositories/message_repository.dart';

class GetMessageStatus {
  final MessageRepository repository;

  GetMessageStatus(this.repository);

  Stream<MessageModel> call(String chatId, String messageId) {
    return repository.getMessageStatus(chatId, messageId);
  }
}
