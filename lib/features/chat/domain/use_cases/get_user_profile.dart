import '../repositories/user_profile_repository.dart';

class GetUserProfile {
  final UserProfileRepository repository;

  GetUserProfile(this.repository);

  Stream<Map<String, dynamic>> call(String userId) {
    return repository.getUserProfile(userId);
  }
}
