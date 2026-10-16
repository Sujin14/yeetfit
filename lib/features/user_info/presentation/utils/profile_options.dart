import 'package:flutter/material.dart';

/// A selectable profile value: [value] is what's stored in Firestore and
/// checked by the validators, [label] is what the user sees.
class ProfileOption {
  final String value;
  final String label;
  final IconData icon;

  const ProfileOption(this.value, this.label, this.icon);
}

// Values must match UserInfoValidators.validateGoal and the calorie
// calculations, which compare against these exact strings.
const fitnessGoalOptions = [
  ProfileOption('weight loss', 'Lose weight', Icons.scale),
  ProfileOption('weight gain', 'Gain weight', Icons.trending_up),
  ProfileOption('muscle building', 'Build muscle', Icons.fitness_center),
];

const activityLevelOptions = [
  ProfileOption('Sedentary', 'Sedentary', Icons.weekend_outlined),
  ProfileOption('Lightly Active', 'Lightly active', Icons.directions_walk),
  ProfileOption('Moderately Active', 'Moderately active', Icons.directions_run),
  ProfileOption('Very Active', 'Very active', Icons.bolt),
];

const genderOptions = ['Male', 'Female', 'Other'];
