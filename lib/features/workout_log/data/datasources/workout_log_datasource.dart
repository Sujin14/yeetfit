import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/workout_log.dart';
import '../models/workout_log_model.dart';

class WorkoutLogDataSource {
  final FirebaseFirestore _firestore;

  WorkoutLogDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Same layout as sleep, water and steps: progress/{metric}/{metric}/{date}.
  CollectionReference<Map<String, dynamic>> _logs(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('workout')
      .collection('workout');

  Stream<WorkoutLog?> watchLog(String userId, String date) {
    return _logs(userId).doc(date).snapshots().map((doc) {
      final data = doc.data();
      return data == null ? null : WorkoutLogModel.fromMap(data, date);
    });
  }

  /// A full overwrite: one workout per day.
  Future<void> saveLog(String userId, WorkoutLog log) {
    return _logs(userId).doc(log.date).set(WorkoutLogModel.toMap(log));
  }
}
