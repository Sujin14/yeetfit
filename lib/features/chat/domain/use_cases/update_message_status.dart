import '../repositories/message_repository.dart';

class UpdateMessageStatus {
  final MessageRepository repository;

  UpdateMessageStatus(this.repository);

  Future<void> call(String chatId, String messageId, String status) {
    return repository.updateMessageStatus(chatId, messageId, status);
  }
}