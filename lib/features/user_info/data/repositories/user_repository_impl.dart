import '../datasources/firestore_user_service.dart';
import '../models/user_info_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreUserService userService;

  UserRepositoryImpl({required this.userService});

  @override
  Future<bool> checkUserExists(String uid) {
    return userService.checkUserExists(uid);
  }

  @override
  Future<void> saveUserData(UserInfoModel userInfo) {
    return userService.saveUserData(userInfo);
  }

  @override
  Future<UserInfoModel?> getUserData(String uid) {
    return userService.getUserData(uid);
  }

  @override
  Future<void> deleteUserData(String uid) {
    return userService.deleteUserData(uid);
  }
}
