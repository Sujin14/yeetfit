import 'package:flutter/material.dart';
import '../../data/models/plan_model.dart';
import '../../domain/entities/plan_exercise.dart';

/// Read-only display accessors over the free-form `details` map.
extension PlanDisplay on PlanModel {
  static const _fixedMealOrder = [
    'Breakfast',
    'Morning Snack',
    'Lunch',
    'Evening Snack',
    'Dinner',
  ];

  bool get isDiet => type == 'diet';

  /// Path segment used by the plans routes (`/plans/:category/:id`).
  String get routeCategory => isDiet ? 'diet' : 'workouts';

  String get categoryLabel => isDiet ? 'Diet' : 'Workout';

  String? get thumbnailUrl => _string('thumbnailUrl') ?? _string('imageUrl');

  String? get imageUrl => _string('imageUrl') ?? _string('thumbnailUrl');

  String? get description => _string('description');

  String? get difficulty => _string('difficulty');

  /// Numeric durations are treated as minutes.
  String? get duration {
    final raw = details['duration'];
    if (raw is num) return '${raw.round()} min';
    return _string('duration');
  }

  List<PlanExercise> get exercises =>
      (details['exercises'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(PlanExercise.fromMap)
          .toList();

  Map<String, dynamic> get meals =>
      Map<String, dynamic>.from(details['meals'] as Map? ?? const {});

  /// Standard meals in day order, then custom meals alphabetically.
  List<String> get orderedMealNames {
    final names = meals.keys.toList();
    final standard = names.where(_fixedMealOrder.contains).toList()
      ..sort(
        (a, b) =>
            _fixedMealOrder.indexOf(a).compareTo(_fixedMealOrder.indexOf(b)),
      );
    final custom = names.where((n) => !_fixedMealOrder.contains(n)).toList()
      ..sort();
    return [...standard, ...custom];
  }

  /// "Duration · Difficulty", falling back to an item count.
  String get metaLine {
    final parts = [duration, difficulty].whereType<String>().toList();
    if (parts.isNotEmpty) return parts.join(' · ');
    return isDiet
        ? '${meals.length} meals · $totalCalories kcal'
        : '${exercises.length} exercises';
  }

  String? _string(String key) {
    final value = details[key];
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

extension PlanIcon on PlanModel {
  IconData get categoryIcon =>
      isDiet ? Icons.restaurant_rounded : Icons.fitness_center_rounded;
}
