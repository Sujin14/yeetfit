abstract class UserRepository {
  Future<Map<String, dynamic>?> getUserData(String userId);
  Future<Map<String, dynamic>> getDailyProgress(String userId, String date);
  Stream<Map<String, dynamic>> getDailyProgressStream(String userId, String date);
  Future<double> getBMI(String userId, String date);
}