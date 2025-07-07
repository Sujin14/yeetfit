// File: lib/features/plans/data/models/plan_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  final String? id;
  final String userId;
  final String type;
  final String title;
  final Map<String, dynamic> details;
  final bool isFavorite;
  final DateTime? createdAt;

  PlanModel({
    this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.details,
    required this.isFavorite,
    this.createdAt,
  });

  factory PlanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final collectionType = doc.reference.parent.path.contains('diets')
        ? 'diet'
        : 'workouts';
    return PlanModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: data['type'] ?? collectionType,
      title: data['title'] ?? '',
      details: Map<String, dynamic>.from(data['details'] ?? {}),
      isFavorite: data['isFavorite'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type,
      'title': title,
      'details': details,
      'isFavorite': isFavorite,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }
}
