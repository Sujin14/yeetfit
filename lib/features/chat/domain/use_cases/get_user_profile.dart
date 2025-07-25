
import '../repositories/chat_repository.dart';

class GetUserProfile {
  final ChatRepository repository;

  GetUserProfile(this.repository);

  Stream<Map<String, dynamic>> call(String userId) {
    return repository.getUserProfile(userId);
  }
}