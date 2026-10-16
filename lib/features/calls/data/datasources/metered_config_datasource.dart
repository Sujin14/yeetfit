import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:yeetfit/core/constants/function_regions.dart';
import 'call_exception.dart';

/// Fetches the realtime messaging API key from the `getCallConfig` Cloud
/// Function. The key only ever lives in memory; it is never bundled with the
/// app or persisted on the device.
class MeteredConfigDataSource {
  static const _configFunction = 'getCallConfig';

  final FirebaseFunctions _functions;
  String? _apiKey;

  MeteredConfigDataSource({FirebaseFunctions? functions})
    : _functions =
          functions ??
          FirebaseFunctions.instanceFor(region: FunctionRegions.general);

  Future<String> getApiKey() async {
    final cached = _apiKey;
    if (cached != null) return cached;
    try {
      final result = await _functions
          .httpsCallable(_configFunction)
          .call<Map<String, dynamic>>();
      final apiKey = result.data['apiKey'] as String?;
      if (apiKey == null || apiKey.isEmpty) {
        throw const CallException('Calling is not configured yet.');
      }
      return _apiKey = apiKey;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('getCallConfig failed: ${e.code} — ${e.message}');
      throw CallException(
        e.code == 'unauthenticated'
            ? 'Please sign in again to make calls.'
            : 'Calling is unavailable right now. Please try again.',
      );
    }
  }
}
