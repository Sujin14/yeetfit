import 'package:rxdart/rxdart.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';
import '../datasources/progress_datasource.dart';
import '../datasources/weight_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource userDataSource;
  final ProgressDataSource progressDataSource;
  final WeightDataSource weightDataSource;

  UserRepositoryImpl({
    required this.userDataSource,
    required this.progressDataSource,
    required this.weightDataSource,
  });

  @override
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    return await userDataSource.getUserData(userId);
  }

  @override
  Future<Map<String, dynamic>> getDailyProgress(String userId, String date) async {
    final userData = await userDataSource.getUserData(userId);
    final stepsData = await progressDataSource.getProgressData(userId, 'steps', date);
    final waterData = await progressDataSource.getProgressData(userId, 'water', date);
    final sleepData = await progressDataSource.getProgressData(userId, 'sleep', date);
    final weightData = await weightDataSource.getWeightData(userId, date);

    return {
      'steps': stepsData?['steps']?.toDouble() ?? 2000.0,
      'stepsGoal': stepsData?['goalSteps']?.toDouble() ?? 2500.0,
      'stepsDescription': stepsData?['description'] ?? 'Steps improve heart health and boost stamina.',
      'water': waterData?['glassesConsumed']?.toDouble() ?? 5.0,
      'waterGoal': waterData?['goalGlasses']?.toDouble() ?? 8.0,
      'waterDescription': waterData?['description'] ?? 'Hydration supports metabolism and energy levels.',
      'calories': 2000.0, // Hardcoded
      'caloriesGoal': 2000.0, // Hardcoded
      'caloriesDescription': 'Calories fuel your daily activities.', // Hardcoded
      'sleep': sleepData?['duration']?.toDouble() ?? 5.0,
      'sleepGoal': sleepData?['goalHours']?.toDouble() ?? 8.0,
      'sleepDescription': sleepData?['description'] ?? 'Sleep enhances recovery and mental focus.',
      'currentWeight': weightData?.currentWeight ?? userData?['currentWeight']?.toDouble() ?? 77.0,
      'weightGoal': weightData?.goalWeight ?? userData?['goalWeight']?.toDouble() ?? 70.0,
      'weightDescription': 'Track your weight to monitor progress.',
    };
  }

  @override
  Stream<Map<String, dynamic>> getDailyProgressStream(String userId, String date) {
    print('UserRepositoryImpl: Streaming progress for userId=$userId, date=$date');
    return CombineLatestStream.combine4(
      userDataSource.getUserData(userId).asStream(),
      progressDataSource.getProgressStream(userId, 'steps', date),
      progressDataSource.getProgressStream(userId, 'water', date),
      progressDataSource.getProgressStream(userId, 'sleep', date),
      (
        Map<String, dynamic>? userData,
        Map<String, dynamic>? stepsData,
        Map<String, dynamic>? waterData,
        Map<String, dynamic>? sleepData,
      ) {
        // Return a Future<Map<String, dynamic>>, will be flattened below
        return weightDataSource.getWeightData(userId, date).then((weightData) {
          print('UserRepositoryImpl: Combined stream update for userId=$userId, date=$date');
          return {
            'steps': stepsData?['steps']?.toDouble() ?? 2000.0,
            'stepsGoal': stepsData?['goalSteps']?.toDouble() ?? 2500.0,
            'stepsDescription': stepsData?['description'] ?? 'Steps improve heart health and boost stamina.',
            'water': waterData?['glassesConsumed']?.toDouble() ?? 5.0,
            'waterGoal': waterData?['goalGlasses']?.toDouble() ?? 8.0,
            'waterDescription': waterData?['description'] ?? 'Hydration supports metabolism and energy levels.',
            'calories': 2000.0, // Hardcoded
            'caloriesGoal': 2000.0, // Hardcoded
            'caloriesDescription': 'Calories fuel your daily activities.', // Hardcoded
            'sleep': sleepData?['duration']?.toDouble() ?? 5.0,
            'sleepGoal': sleepData?['goalHours']?.toDouble() ?? 8.0,
            'sleepDescription': sleepData?['description'] ?? 'Sleep enhances recovery and mental focus.',
            'currentWeight': weightData?.currentWeight ?? userData?['currentWeight']?.toDouble() ?? 77.0,
            'weightGoal': weightData?.goalWeight ?? userData?['goalWeight']?.toDouble() ?? 70.0,
            'weightDescription': 'Track your weight to monitor progress.',
          };
        });
      },
    )
    .asyncExpand((futureMap) => Stream.fromFuture(futureMap))
    .handleError((e) {
      print('UserRepositoryImpl: Error streaming progress for userId=$userId, date=$date: $e');
      throw e;
    });
  }

  @override
  Future<double> getBMI(String userId, String date) async {
    final userData = await userDataSource.getUserData(userId);
    final progress = await getDailyProgress(userId, date);
    final height = userData?['height']?.toDouble() ?? 181.0;
    final weight = progress['currentWeight']?.toDouble() ?? userData?['currentWeight']?.toDouble() ?? 77.0;
    final heightInMeters = height / 100;
    print('UserRepositoryImpl: Calculating BMI for userId=$userId, height=$height, weight=$weight');
    return weight / (heightInMeters * heightInMeters);
  }
}