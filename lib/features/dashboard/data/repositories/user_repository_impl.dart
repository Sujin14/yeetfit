// lib/features/dashboard/data/repositories/user_repository_impl.dart
import 'package:rxdart/rxdart.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/progress_datasource.dart';
import '../datasources/user_datasource.dart';
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
    final mealData = await progressDataSource.getProgressData(userId, 'meal', date);
    final weightData = await weightDataSource.getWeightData(userId, date);

    return {
      'steps': stepsData?['steps']?.toDouble() ?? 0.0,
      'stepsGoal': stepsData?['goalSteps']?.toDouble() ?? 10000.0,
      'stepsDescription': stepsData?['description'] ?? 'Steps improve heart health and boost stamina.',
      'water': waterData?['glassesConsumed']?.toDouble() ?? 0.0,
      'waterGoal': waterData?['goalGlasses']?.toDouble() ?? 8.0,
      'waterDescription': waterData?['description'] ?? 'Hydration supports metabolism and energy levels.',
      'calories': mealData?['calories']?.toDouble() ?? 0.0,
      'caloriesGoal': mealData?['caloriesGoal']?.toDouble() ?? 2000.0,
      'protein': mealData?['protein']?.toDouble() ?? 0.0,
      'carbs': mealData?['carbs']?.toDouble() ?? 0.0,
      'fat': mealData?['fat']?.toDouble() ?? 0.0,
      'caloriesDescription': mealData?['description'] ?? 'Track your daily nutrition to meet your goals.',
      'sleep': sleepData?['duration']?.toDouble() ?? 0.0,
      'sleepGoal': sleepData?['goalHours']?.toDouble() ?? 8.0,
      'sleepDescription': sleepData?['description'] ?? 'Sleep enhances recovery and mental focus.',
      'currentWeight': weightData?.currentWeight ?? userData?['currentWeight']?.toDouble() ?? 77.0,
      'weightGoal': weightData?.goalWeight ?? userData?['goalWeight']?.toDouble() ?? 70.0,
      'weightDescription': 'Track your weight to monitor progress.',
      'hasData': stepsData != null || waterData != null || sleepData != null || mealData != null || weightData != null,
    };
  }

  @override
  Stream<Map<String, dynamic>> getDailyProgressStream(String userId, String date) {
    return CombineLatestStream.combine5(
      userDataSource.getUserData(userId).asStream(),
      progressDataSource.getProgressStream(userId, 'steps', date),
      progressDataSource.getProgressStream(userId, 'water', date),
      progressDataSource.getProgressStream(userId, 'sleep', date),
      progressDataSource.getProgressStream(userId, 'meal', date),
      (userData, stepsData, waterData, sleepData, mealData) {
        return weightDataSource.getWeightData(userId, date).then((weightData) {
          return {
            'steps': stepsData?['steps']?.toDouble() ?? 0.0,
            'stepsGoal': stepsData?['goalSteps']?.toDouble() ?? 10000.0,
            'stepsDescription': stepsData?['description'] ?? 'Steps improve heart health and boost stamina.',
            'water': waterData?['glassesConsumed']?.toDouble() ?? 0.0,
            'waterGoal': waterData?['goalGlasses']?.toDouble() ?? 8.0,
            'waterDescription': waterData?['description'] ?? 'Hydration supports metabolism and energy levels.',
            'calories': mealData?['calories']?.toDouble() ?? 0.0,
            'caloriesGoal': mealData?['caloriesGoal']?.toDouble() ?? 2000.0,
            'protein': mealData?['protein']?.toDouble() ?? 0.0,
            'carbs': mealData?['carbs']?.toDouble() ?? 0.0,
            'fat': mealData?['fat']?.toDouble() ?? 0.0,
            'caloriesDescription': mealData?['description'] ?? 'Track your daily nutrition to meet your goals.',
            'sleep': sleepData?['duration']?.toDouble() ?? 0.0,
            'sleepGoal': sleepData?['goalHours']?.toDouble() ?? 8.0,
            'sleepDescription': sleepData?['description'] ?? 'Sleep enhances recovery and mental focus.',
            'currentWeight': weightData?.currentWeight ?? userData?['currentWeight']?.toDouble() ?? 77.0,
            'weightGoal': weightData?.goalWeight ?? userData?['goalWeight']?.toDouble() ?? 70.0,
            'weightDescription': 'Track your weight to monitor progress.',
            'hasData': stepsData != null || waterData != null || sleepData != null || mealData != null || weightData != null,
          };
        });
      },
    ).asyncExpand((futureMap) => Stream.fromFuture(futureMap)).handleError((e) => throw e);
  }

  @override
  Future<double> getBMI(String userId, String date) async {
    final userData = await userDataSource.getUserData(userId);
    final progress = await getDailyProgress(userId, date);
    final height = (userData?['height'] as num?)?.toDouble() ?? 0.0;
    final weight = progress['currentWeight']?.toDouble() ?? (userData?['currentWeight'] as num?)?.toDouble() ?? 0.0;
    if (height <= 0 || weight <= 0) return 0.0;
    return weight / ((height / 100) * (height / 100));
  }
}