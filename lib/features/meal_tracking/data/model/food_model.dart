import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String date;
  final String mealType;
  final String foodName;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;
  final double quantity;
  final String? image;

  FoodItem({
    required this.date,
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.quantity,
    this.image,
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
      quantity: (map['quantity'] as num?)?.toDouble() ?? 100.0,
      image: map['image'] as String?,
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
      'quantity': quantity,
      'image': image,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json, {required double quantity}) {
    final nutrients = json['nutrients'] as Map<String, dynamic>? ?? {};
    final measures = json['measures'] as List<dynamic>? ?? [];
    final servingWeight = measures.isNotEmpty
        ? (measures.firstWhere(
            (m) => m['label'] == 'Serving',
            orElse: () => {'weight': 100.0},
          )['weight'] as num?)?.toDouble() ?? 100.0
        : 100.0;
    final scale = quantity / servingWeight;
    return FoodItem(
      date: DateTime.now().toIso8601String().split('T')[0],
      mealType: '',
      foodName: json['label'] ?? 'Unknown Food',
      calories: ((nutrients['ENERC_KCAL'] as num?)?.toDouble() ?? 0.0) * scale,
      protein: ((nutrients['PROCNT'] as num?)?.toDouble() ?? 0.0) * scale,
      fat: ((nutrients['FAT'] as num?)?.toDouble() ?? 0.0) * scale,
      carbs: ((nutrients['CHOCDF'] as num?)?.toDouble() ?? 0.0) * scale,
      fiber: ((nutrients['FIBTG'] as num?)?.toDouble() ?? 0.0) * scale,
      quantity: quantity,
      image: json['image'] as String?,
    );
  }
}