import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/food_model.dart';

class FoodDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FoodItem>> getFoodData(String userId, String date, String mealType) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('food')
        .collection('food')
        .where('date', isEqualTo: date)
        .where('mealType', isEqualTo: mealType)
        .get();

    return querySnapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList();
  }

    Future<double> getCalorieGoal(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('food')
        .collection('food')
        .doc('$date-goal');

    final doc = await docRef.get();

    if (!doc.exists) return 0.0;

    final data = doc.data()!;
    final raw = (data['calorieGoal'] as num?)?.toDouble();

    if (raw == null) return 0.0;

    if (raw == 1750.0) return 0.0;

    return raw;
  }


  Future<void> addFoodEntry(
    String userId,
    String date,
    String mealType,
    String foodName,
    double calories,
    double protein,
    double fat,
    double carbs,
    double fiber,
    double quantity,
    String? image,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('food')
        .collection('food')
        .doc();

    await docRef.set({
      'date': date,
      'mealType': mealType,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'fiber': fiber,
      'quantity': quantity,
      'image': image,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    });
  }

  Future<List<FoodItem>> getWeeklyFoodData(
    String userId,
    DateTime startDate,
    DateTime endDate,
    String mealType,
  ) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('food')
        .collection('food')
        .where('mealType', isEqualTo: mealType)
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    return querySnapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList();
  }

  Future<void> setCalorieGoal(String userId, String date, double newGoal) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('food')
        .collection('food')
        .doc('$date-goal');

    await docRef.set({
      'date': date,
      'calorieGoal': newGoal,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    }, SetOptions(merge: true));
  }
}