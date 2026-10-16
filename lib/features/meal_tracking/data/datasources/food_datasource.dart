import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:yeetfit/core/services/streak_service.dart';
import '../../domain/entities/food_item.dart';
import '../model/food_model.dart';

/// Today's food log in Firestore at `users/{uid}/progress/food/food`.
/// Legacy `{date}-goal` docs may still sit alongside the entries; daily
/// targets now live on the `users/{uid}` profile.
class FoodDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _food(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('food')
      .collection('food');

  static Timestamp _startOfDay(String date) =>
      Timestamp.fromDate(DateTime.parse('$date 00:00:00'));

  /// All of [date]'s entries in one listener; the `{date}-goal` doc shares
  /// the date and is skipped.
  Stream<List<FoodItem>> watchTodayMeals(String userId, String date) {
    return _food(userId)
        .where('date', isEqualTo: date)
        .snapshots()
        .map(
          (snapshot) => [
            for (final doc in snapshot.docs)
              if (doc.id != _goalDocId(date))
                FoodItemModel.fromMap(doc.data(), id: doc.id),
          ],
        );
  }

  static String _goalDocId(String date) => '$date-goal';

  Future<void> deleteFoodEntry(String userId, String entryId) async {
    await _food(userId).doc(entryId).delete();
    unawaited(_syncCalorieChallenges(userId));
  }

  /// Logs [item] under today's date, whatever its own `date` is.
  Future<void> addFoodEntry(String userId, FoodItem item) async {
    final date = StreakService.todayKey();
    await _food(userId).add({
      ...FoodItemModel.toMap(item),
      'date': date,
      'timestamp': _startOfDay(date),
    });
    unawaited(StreakService().checkAfterLog(userId));
    unawaited(_syncCalorieChallenges(userId));
  }

  // Challenges track the day's total, not the single entry just added.
  Future<void> _syncCalorieChallenges(String userId) async {
    try {
      final snapshot = await _food(
        userId,
      ).where('date', isEqualTo: StreakService.todayKey()).get();
      final totalCalories = snapshot.docs.fold<double>(
        0,
        (total, doc) =>
            total + ((doc.data()['calories'] as num?)?.toDouble() ?? 0),
      );
      await StreakService().updateChallengeProgress(
        userId,
        'calories',
        totalCalories,
      );
    } catch (e) {
      debugPrint('Calorie challenge sync failed: $e');
    }
  }

  /// Every document from the last 7 days (today included). Goal docs come
  /// back too, with an empty `mealType`.
  Future<List<FoodItem>> getWeeklyFoodData(String userId) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day - 6);
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final snapshot = await _food(userId)
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();
    return snapshot.docs
        .map((doc) => FoodItemModel.fromMap(doc.data()))
        .toList();
  }
}
