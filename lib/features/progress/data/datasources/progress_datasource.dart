import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/daily_progress_model.dart';


abstract class ProgressDataSource { Future<List> getMonthlyProgress(DateTime month, {String? metric}); }

class ProgressDataSourceImpl implements ProgressDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProgressDataSourceImpl({required this.firestore, required this.auth});

  @override
  Future<List<DailyProgressModel>> getMonthlyProgress(DateTime month, {String? metric}) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    final daysInMonth = endOfMonth.day;
    final progressMap = <String, Map<String, Map<String, dynamic>>>{};

    try {
      // List of subcollections to query
      final subcollections = metric != null
          ? [metric.toLowerCase()]
          : ['food', 'sleep', 'steps', 'water', 'weight'];

      for (final subcollection in subcollections) {
        if (subcollection == 'food') {
          final mealTypes = ['breakfast', 'lunch', 'dinner', 'snacks'];
          for (final mealType in mealTypes) {
            final querySnapshot = await firestore
                .collection('users')
                .doc(userId)
                .collection('progress')
                .doc(subcollection)
                .collection(mealType)
                .where(FieldPath.documentId, isGreaterThanOrEqualTo: startOfMonth.toIso8601String().substring(0, 10))
                .where(FieldPath.documentId, isLessThanOrEqualTo: endOfMonth.toIso8601String().substring(0, 10))
                .get()
                .timeout(const Duration(seconds: 10), onTimeout: () {
                  throw TimeoutException('Failed to fetch $subcollection/$mealType data');
                });

            for (var doc in querySnapshot.docs) {
              progressMap.putIfAbsent(doc.id, () => {});
              progressMap[doc.id]!['food_$mealType'] = doc.data();
            }
          }
        } else {
          final querySnapshot = await firestore
              .collection('users')
              .doc(userId)
              .collection('progress')
              .doc(subcollection)
              .collection(subcollection)
              .where(FieldPath.documentId, isGreaterThanOrEqualTo: startOfMonth.toIso8601String().substring(0, 10))
              .where(FieldPath.documentId, isLessThanOrEqualTo: endOfMonth.toIso8601String().substring(0, 10))
              .get()
              .timeout(const Duration(seconds: 10), onTimeout: () {
                throw TimeoutException('Failed to fetch $subcollection data');
              });

          for (var doc in querySnapshot.docs) {
            progressMap.putIfAbsent(doc.id, () => {});
            progressMap[doc.id]![subcollection] = doc.data();
          }
        }
      }

      final List<DailyProgressModel> progressList = [];
      for (int day = 1; day <= daysInMonth; day++) {
        final dateStr = DateTime(month.year, month.month, day).toIso8601String().substring(0, 10);
        progressList.add(DailyProgressModel.fromFirestore(
          dateStr,
          progressMap[dateStr] ?? {},
        ));
      }

      return progressList;
    } catch (e) {
      rethrow;
    }
  }
}