import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/food_model.dart';

class FoodDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<FoodItem?> getFoodData(String userId, String date, String mealType) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('food')
        .collection('food')
        .doc('$date-$mealType'); // Use a composite ID to store mealType and date

    final doc = await docRef.get();

    if (doc.exists) {
      return FoodItem.fromMap(doc.data()!);
    }
    return null;
  }

  Future<double> getCalorieGoal(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('food')
        .collection('food')
        .doc('$date-goal'); // Store calorie goal with a specific suffix

    final doc = await docRef.get();
    return doc.exists ? (doc.data()!['calorieGoal'] as num?)?.toDouble() ?? 1750.0 : 1750.0;
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
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('food')
        .collection('food')
        .doc('$date-$mealType'); // Use a composite ID

    await docRef.set({
      'date': date,
      'mealType': mealType, // Store mealType explicitly
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'fiber': fiber,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    }, SetOptions(merge: true));
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
        .where('mealType', isEqualTo: mealType) // Filter by mealType
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