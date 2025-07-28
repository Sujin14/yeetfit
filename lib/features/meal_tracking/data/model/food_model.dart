import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String date;
  final String mealType; // New field
  final String foodName;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;

  FoodItem({
    required this.date,
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
  });

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      mealType: map['mealType'] ?? '',
      foodName: map['foodName'] ?? '',
      calories: (map['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (map['protein'] as num?)?.toDouble() ?? 0.0,
      fat: (map['fat'] as num?)?.toDouble() ?? 0.0,
      carbs: (map['carbs'] as num?)?.toDouble() ?? 0.0,
      fiber: (map['fiber'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'mealType': mealType,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'fiber': fiber,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      date: DateTime.now().toIso8601String().split('T')[0],
      mealType: '', 
      foodName: json['label'] ?? '',
      calories: (json['nutrients']['ENERC_KCAL'] as num?)?.toDouble() ?? 0.0,
      protein: (json['nutrients']['PROCNT'] as num?)?.toDouble() ?? 0.0,
      fat: (json['nutrients']['FAT'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['nutrients']['CHOCDF'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['nutrients']['FIBTG'] as num?)?.toDouble() ?? 0.0,
    );
  }
}