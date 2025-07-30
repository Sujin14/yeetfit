import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/user_datasource.dart';
import '../../data/datasources/progress_datasource.dart';
import '../../data/datasources/weight_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/get_user_data.dart';
import '../../domain/usecases/get_daily_progress.dart';
import '../../domain/usecases/get_bmi.dart';

final userDataSourceProvider = Provider((ref) => UserDataSource());
final progressDataSourceProvider = Provider((ref) => ProgressDataSource());
final weightDataSourceProvider = Provider((ref) => WeightDataSource());

final userRepositoryProvider = Provider((ref) => UserRepositoryImpl(
      userDataSource: ref.read(userDataSourceProvider),
      progressDataSource: ref.read(progressDataSourceProvider),
      weightDataSource: ref.read(weightDataSourceProvider),
    ));

final getUserDataProvider = Provider((ref) => GetUserData(ref.read(userRepositoryProvider)));
final getDailyProgressProvider = Provider((ref) => GetDailyProgress(ref.read(userRepositoryProvider)));
final getBMIProvider = Provider((ref) => GetBMI(ref.read(userRepositoryProvider)));

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final userDataFutureProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
  print('userDataFutureProvider: Fetching for userId=$userId');
  return await ref.read(getUserDataProvider).call(userId);
});

final dailyProgressStreamProvider = StreamProvider.family<Map<String, dynamic>, String>((ref, userId) async* {
  final date = ref.watch(selectedDateProvider).toIso8601String().split('T')[0];
  print('dailyProgressStreamProvider: Streaming for userId=$userId, date=$date');
  yield* ref.read(getDailyProgressProvider).stream(userId, date);
});

final bmiFutureProvider = FutureProvider.family<double, String>((ref, userId) async {
  final date = ref.watch(selectedDateProvider).toIso8601String().split('T')[0];
  print('bmiFutureProvider: Fetching for userId=$userId, date=$date');
  return await ref.read(getBMIProvider).call(userId, date);
});