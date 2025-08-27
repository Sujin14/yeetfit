import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  final String? id;
  final String title;
  final String type;
  final String userId;
  final String? assignedBy;
  final Map<String, dynamic> details;
  final bool isFavorite;
  final Timestamp createdAt;
  final int totalCalories;
  final Map<String, double> totalMacronutrients;

  PlanModel({
    this.id,
    required this.title,
    required this.type,
    required this.userId,
    this.assignedBy,
    required this.details,
    required this.isFavorite,
    required this.createdAt,
    required this.totalCalories,
    this.totalMacronutrients = const {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
  });

  factory PlanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final collectionType = doc.reference.parent.path.contains('diets') ? 'diet' : 'workouts';
    return PlanModel(
      id: doc.id,
      title: data['title'] ?? 'Unnamed Plan',
      type: data['type'] ?? collectionType,
      userId: data['userId'] ?? '',
      assignedBy: data['assignedBy'],
      details: Map<String, dynamic>.from(data['details'] ?? {}),
      isFavorite: data['isFavorite'] ?? false,
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      totalCalories: data['totalCalories'] ?? 0,
      totalMacronutrients: Map<String, double>.from(
        data['totalMacronutrients'] ?? {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'userId': userId,
      'assignedBy': assignedBy,
      'details': details,
      'isFavorite': isFavorite,
      'createdAt': createdAt,
      'totalCalories': totalCalories,
      'totalMacronutrients': totalMacronutrients,
    };
  }
}