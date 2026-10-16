import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/food_search_datasource.dart';
import '../../data/model/food_model.dart';
import '../../domain/entities/food_item.dart';

final foodSearchDataSourceProvider = Provider<FoodSearchDataSource>(
  (ref) => FoodSearchDataSource(),
);

final foodSearchControllerProvider =
    NotifierProvider.autoDispose<FoodSearchController, FoodSearchState>(
      FoodSearchController.new,
    );

class FoodSearchState {
  static const double defaultQuantityGrams = 100;

  final String query;
  final double quantityGrams;

  /// Raw Edamam hints; empty data while the query is blank.
  final AsyncValue<List<Map<String, dynamic>>> results;

  const FoodSearchState({
    this.query = '',
    this.quantityGrams = defaultQuantityGrams,
    this.results = const AsyncData([]),
  });

  FoodSearchState copyWith({
    String? query,
    double? quantityGrams,
    AsyncValue<List<Map<String, dynamic>>>? results,
  }) {
    return FoodSearchState(
      query: query ?? this.query,
      quantityGrams: quantityGrams ?? this.quantityGrams,
      results: results ?? this.results,
    );
  }

  /// Results scaled to [quantityGrams] for [mealType]; entries without
  /// usable nutrition data are skipped.
  List<FoodItem> itemsFor(String mealType) {
    final hints = results.value ?? const [];
    final items = <FoodItem>[];
    for (final hint in hints) {
      final food = hint['food'];
      if (food is! Map<String, dynamic>) continue;
      try {
        items.add(
          FoodItemModel.fromEdamamJson(
            food,
            quantity: quantityGrams,
          ).copyWith(mealType: mealType),
        );
      } catch (e) {
        debugPrint('Skipping unreadable food result: $e');
      }
    }
    return items;
  }
}

class FoodSearchController extends Notifier<FoodSearchState> {
  static const _debounce = Duration(milliseconds: 400);
  static const _minQueryLength = 2;
  static const _cacheSize = 20;

  Timer? _debounceTimer;

  /// Bumped on every query change so a response for an older query is dropped
  /// (callable requests can't be aborted).
  int _latestRequest = 0;

  /// Cache key of the search that is debouncing or in flight.
  String? _pendingKey;

  /// Keyed by lowercased, trimmed query. Map iteration order is insertion
  /// order, so hits are re-inserted to keep the oldest entry first.
  final Map<String, List<Map<String, dynamic>>> _cache = {};

  @override
  FoodSearchState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    return const FoodSearchState();
  }

  void updateQuery(String query) {
    final trimmed = query.trim();
    final key = trimmed.toLowerCase();
    // e.g. a trailing space: the same search is already on its way.
    if (key == _pendingKey) return;

    _debounceTimer?.cancel();
    _pendingKey = null;
    final request = ++_latestRequest;

    if (trimmed.length < _minQueryLength) {
      state = state.copyWith(query: '', results: const AsyncData([]));
      return;
    }

    final cached = _cache.remove(key);
    if (cached != null) {
      _cache[key] = cached;
      state = state.copyWith(query: trimmed, results: AsyncData(cached));
      return;
    }

    _pendingKey = key;
    state = state.copyWith(query: trimmed, results: const AsyncLoading());
    _debounceTimer = Timer(_debounce, () => _search(trimmed, key, request));
  }

  /// Re-runs the current query after a failed search.
  void retry() => updateQuery(state.query);

  void updateQuantity(String text) {
    final grams = double.tryParse(text.trim());
    state = state.copyWith(
      quantityGrams: grams != null && grams > 0
          ? grams
          : FoodSearchState.defaultQuantityGrams,
    );
  }

  Future<void> _search(String query, String key, int request) async {
    try {
      final hints = await ref.read(foodSearchDataSourceProvider).search(query);
      // Cached even when superseded, so returning to this query is free.
      _remember(key, hints);
      if (!ref.mounted || request != _latestRequest) return;
      _pendingKey = null;
      state = state.copyWith(results: AsyncData(hints));
    } catch (e, stack) {
      debugPrint('Food search failed: $e');
      if (!ref.mounted || request != _latestRequest) return;
      _pendingKey = null;
      state = state.copyWith(results: AsyncError(e, stack));
    }
  }

  void _remember(String key, List<Map<String, dynamic>> hints) {
    _cache
      ..remove(key)
      ..[key] = hints;
    if (_cache.length > _cacheSize) _cache.remove(_cache.keys.first);
  }
}
