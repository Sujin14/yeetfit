import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:yeetfit/core/constants/function_regions.dart';
import '../../domain/entities/scanned_meal.dart';

class MealScanException implements Exception {
  final String message;

  const MealScanException(this.message);

  @override
  String toString() => message;
}

/// Sends a meal photo to Gemini through the `callGemini` Cloud Function and
/// parses its nutrition estimate.
class MealScanDataSource {
  static const _geminiFunction = 'callGemini';
  static const _unreadableResponse =
      "Couldn't read the scan result. Please try another photo.";
  static const _prompt = '''
Analyze this meal photo. Return ONLY a JSON object, no other text:
{"foodName":"...","servingSize":"...","calories":0,"protein":0,"carbs":0,"fat":0}
Numbers: calories in kcal, others in grams. Estimate for a typical serving.
If you cannot identify food in the image, return:
{"error":"Could not identify food in this image"}
''';

  final FirebaseFunctions _functions;

  MealScanDataSource({FirebaseFunctions? functions})
    : _functions =
          functions ??
          FirebaseFunctions.instanceFor(region: FunctionRegions.general);

  /// [mimeType] is e.g. `image/jpeg` or `image/png`. Throws
  /// [MealScanException] when the photo can't be analysed.
  Future<ScannedMeal> scanImage(Uint8List bytes, String mimeType) async {
    final String text;
    try {
      final result = await _functions
          .httpsCallable(_geminiFunction)
          .call<Map<String, dynamic>>({
            'prompt': _prompt,
            'imageBase64': base64Encode(bytes),
            'mimeType': mimeType,
          });
      text = (result.data['text'] as String?) ?? '';
    } on FirebaseFunctionsException catch (e) {
      debugPrint('Functions error: ${e.code} — ${e.message} — ${e.details}');
      throw MealScanException(
        e.code == 'unauthenticated'
            ? 'Please sign in again to scan meals.'
            : 'Meal scanning is unavailable right now. Please try again.',
      );
    }
    return _parse(text);
  }

  ScannedMeal _parse(String text) {
    // Gemini sometimes wraps the JSON in markdown fences; take the outermost
    // object instead of decoding the raw text.
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start == -1 || end <= start) {
      throw const MealScanException(_unreadableResponse);
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(text.substring(start, end + 1));
    } on FormatException {
      throw const MealScanException(_unreadableResponse);
    }
    if (decoded is! Map<String, dynamic>) {
      throw const MealScanException(_unreadableResponse);
    }

    final error = decoded['error'];
    if (error is String && error.isNotEmpty) throw MealScanException(error);

    final meal = ScannedMeal.fromJson(decoded);
    if (meal.foodName.isEmpty) {
      throw const MealScanException('Could not identify food in this image');
    }
    return meal;
  }
}
