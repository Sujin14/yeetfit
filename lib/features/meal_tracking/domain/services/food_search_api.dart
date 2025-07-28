import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> searchFood(String query) async {
  if (query.isEmpty) {
    return []; // Return empty list for empty query
  }

  const appId = '0e9cc127';
  const appKey = '65a2afc3ac9099090ae200ffab82b453';
  final url = 'https://api.edamam.com/api/food-database/v2/parser?app_id=$appId&app_key=$appKey&ingr=$query';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final hints = data['hints'];
      if (hints is List) {
        return hints.cast<Map<String, dynamic>>();
      } else {
        return []; // Return empty list if hints is not a List
      }
    } else {
      throw Exception('Failed to load food data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error searching food: $e');
  }
}