import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:yeetfit/core/constants/function_regions.dart';

/// Food search failed upstream; [message] is the server's reason.
class FoodSearchException implements Exception {
  final String message;

  /// Edamam answered HTTP 429 (Too Many Requests).
  final bool isRateLimited;

  const FoodSearchException(this.message, {this.isRateLimited = false});

  @override
  String toString() => message;
}

/// Edamam food search, proxied through the `searchFood` Cloud Function so the
/// API credentials stay server-side.
class FoodSearchDataSource {
  static const _searchFunction = 'searchFood';

  final FirebaseFunctions _functions;

  FoodSearchDataSource({FirebaseFunctions? functions})
    : _functions =
          functions ??
          FirebaseFunctions.instanceFor(region: FunctionRegions.general);

  /// Edamam `hints`; each has a `food` map with `label`, `image` and
  /// per-100 g `nutrients`.
  Future<List<Map<String, dynamic>>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    try {
      final result = await _functions
          .httpsCallable(_searchFunction)
          .call<Map<String, dynamic>>({'query': trimmed});
      final hints = result.data['hints'];
      if (hints is! List) return const [];
      return hints.whereType<Map<String, dynamic>>().toList();
    } on FirebaseFunctionsException catch (e) {
      debugPrint('Functions error: ${e.code} — ${e.message} — ${e.details}');
      final reason = '${e.message} ${e.details ?? ''}';
      throw FoodSearchException(
        '${e.code}: ${e.message}',
        isRateLimited:
            e.code == 'resource-exhausted' ||
            reason.contains('429') ||
            reason.contains('Too Many Requests'),
      );
    }
  }
}
