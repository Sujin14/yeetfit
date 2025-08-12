import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/weight_model.dart';

class WeightDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<WeightData?> getWeightData(String userId, String date) async {
    print(
      'WeightDataSource: Fetching weight data for userId=$userId, date=$date',
    );
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('weight')
        .collection('weight')
        .doc(date);
    try {
      final doc = await docRef.get();
      if (doc.exists) {
        print(
          'WeightDataSource: Weight data found for userId=$userId, date=$date: ${doc.data()}',
        );
        return WeightData.fromMap(doc.data()!);
      }
      print(
        'WeightDataSource: No weight data found for userId=$userId, date=$date',
      );
      return null;
    } catch (e) {
      print('WeightDataSource: Error for userId=$userId, date=$date: $e');
      rethrow;
    }
  }

  Stream<WeightData?> getWeightStream(String userId, String date) {
    print(
      'WeightDataSource: Streaming weight data for userId=$userId, date=$date',
    );
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('weight')
        .collection('weight')
        .doc(date)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            print(
              'WeightDataSource: Weight stream update for userId=$userId, date=$date: ${doc.data()}',
            );
            return WeightData.fromMap(doc.data()!);
          }
          print(
            'WeightDataSource: No weight stream data for userId=$userId, date=$date',
          );
          return null;
        })
        .handleError((e) {
          print(
            'WeightDataSource: Error streaming weight data for userId=$userId, date=$date: $e',
          );
          throw e;
        });
  }
}
