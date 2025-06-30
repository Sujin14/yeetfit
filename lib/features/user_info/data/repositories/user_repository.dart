import '../../domain/models/user_info_model.dart';

abstract class UserRepository {
  Future<bool> checkUserExists(String uid);
  Future<void> saveUserData(UserInfoModel userInfo);
  Future<UserInfoModel?> getUserData(String uid);
}
