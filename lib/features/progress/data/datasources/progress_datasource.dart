import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/daily_progress_model.dart';

abstract class ProgressDataSource {
  Future<List<DailyProgressModel>> getMonthlyProgress(DateTime month, {String? metric});
}

class ProgressDataSourceImpl implements ProgressDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProgressDataSourceImpl({required this.firestore, required this.auth});

  @override
  Future<List<DailyProgressModel>> getMonthlyProgress(DateTime month, {String? metric}) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      print('[DataSource] User not authenticated');
      throw Exception('User not authenticated');
    }

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = endOfMonth.day;
    final startStr = startOfMonth.toIso8601String().substring(0, 10);
    final endStr = endOfMonth.toIso8601String().substring(0, 10);

    print('[DataSource] Getting monthly progress for user=$userId '
        'month=${month.year}-${month.month} range=$startStr..$endStr '
        'metric=${metric ?? "ALL"}');

    final progressMap = <String, Map<String, Map<String, dynamic>>>{};

    try {
      final metrics = metric != null
          ? [metric.toLowerCase()]
          : ['food', 'sleep', 'steps', 'water', 'weight'];

      for (final m in metrics) {
        print('[DataSource] Fetching metric: $m');

        final dataPath = firestore
            .collection('users')
            .doc(userId)
            .collection('progress')
            .doc(m)
            .collection(m);

        print('[DataSource] Querying data at: users/$userId/progress/$m/$m '
            'where id in [$startStr..$endStr]');
        final dataSnap = await dataPath
            .where(FieldPath.documentId, isGreaterThanOrEqualTo: startStr)
            .where(FieldPath.documentId, isLessThanOrEqualTo: endStr)
            .get()
            .timeout(const Duration(seconds: 12), onTimeout: () {
          throw TimeoutException('Timed out fetching $m data');
        });

        print('[DataSource] $m - progress docs returned: ${dataSnap.docs.length}');
        for (final doc in dataSnap.docs) {
          print('[DataSource]   doc: ${doc.id} => ${doc.data()}');
          progressMap.putIfAbsent(doc.id, () => {});
          progressMap[doc.id]![m] = doc.data();
        }
      }

      // Build final list in day order
      final List<DailyProgressModel> progressList = [];
      for (int day = 1; day <= daysInMonth; day++) {
        final dateStr = DateTime(month.year, month.month, day)
            .toIso8601String()
            .substring(0, 10);

        progressList.add(
          DailyProgressModel.fromFirestore(
            dateStr,
            progressMap[dateStr] ?? {},
          ),
        );
      }

      print('[DataSource] Built progressList with length=${progressList.length}');
      return progressList;
    } catch (e, st) {
      print('[DataSource] Error fetching progress: $e\n$st');
      rethrow;
    }
  }
}
