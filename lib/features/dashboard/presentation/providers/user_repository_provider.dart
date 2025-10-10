import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/progress_datasource.dart';
import '../../data/datasources/user_datasource.dart';
import '../../data/datasources/weight_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';


final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userDataSource = UserDataSource();
  final progressDataSource = ProgressDataSource();
  final weightDataSource = WeightDataSource();

  return UserRepositoryImpl(
    userDataSource: userDataSource,
    progressDataSource: progressDataSource,
    weightDataSource: weightDataSource,
  );
});