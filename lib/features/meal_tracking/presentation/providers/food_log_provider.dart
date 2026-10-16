import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/food_item.dart';
import 'food_provider.dart';

/// Writes to today's food log. Loading while an add is in flight; the
/// today-meals stream picks up the change, so nothing is refetched here.
final foodLogControllerProvider =
    AsyncNotifierProvider.autoDispose<FoodLogController, void>(
      FoodLogController.new,
    );

class FoodLogController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Logs [item] under its `mealType` via [AddFoodEntry]. Returns `true` on
  /// success.
  Future<bool> addToLog({
    required String userId,
    required FoodItem item,
  }) async {
    final addFoodEntry = ref.read(addFoodEntryProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => addFoodEntry(userId, item));
    if (result case AsyncError(:final error)) {
      debugPrint('Adding food entry failed: $error');
    }
    if (ref.mounted) {
      state = result;
      ref.invalidate(weeklyFoodDataProvider(userId));
    }
    return !result.hasError;
  }

  /// The today-meals listener drops the entry as soon as the local write
  /// lands; throws if the delete fails.
  Future<void> removeEntry({
    required String userId,
    required String entryId,
  }) async {
    final repository = ref.read(foodRepositoryProvider);
    await repository.deleteFoodEntry(userId, entryId);
    if (ref.mounted) ref.invalidate(weeklyFoodDataProvider(userId));
  }
}
