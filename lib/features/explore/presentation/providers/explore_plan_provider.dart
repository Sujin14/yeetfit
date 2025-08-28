import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

final planProvider = StateNotifierProvider<ExploreNotifier, AsyncValue<void>>(
    (ref) => ExploreNotifier(ref));

class ExploreNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ExploreNotifier(this._ref) : super(const AsyncValue.data(null));

  void navigateToDietPlan(BuildContext context) {
    context.push('/plans/diet');
  }

  void navigateToWorkoutPlan(BuildContext context) {
    context.push('/plans/workouts');
  }
}