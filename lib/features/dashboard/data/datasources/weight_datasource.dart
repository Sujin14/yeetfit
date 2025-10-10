// lib/features/dashboard/data/datasources/weight_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/weight_model.dart';

class WeightDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<WeightData?> getWeightData(String userId, String date) async {
    
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
        
        return WeightData.fromMap(doc.data()!);
      }
      
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Stream<WeightData?> getWeightStream(String userId, String date) {
    
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
            
            return WeightData.fromMap(doc.data()!);
          }
          
          return null;
        })
        .handleError((e) {
         
          throw e;
        });
  }
}