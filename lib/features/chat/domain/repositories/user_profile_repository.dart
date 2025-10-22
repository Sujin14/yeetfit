abstract class UserProfileRepository {
  Stream<Map<String, dynamic>> getUserProfile(String userId);
}
