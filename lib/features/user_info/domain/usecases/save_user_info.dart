import '../repositories/user_repository.dart';
import '../../data/models/user_info_model.dart';

class SaveUserInfo {
  final UserRepository repository;

  SaveUserInfo(this.repository);

  Future<void> call(UserInfoModel userInfo) async {
    await repository.saveUserData(userInfo);
  }
}
