import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../data/model/food_model.dart';

Future<List<FoodItem>> searchFood(String query) async {
  const appId = '0e9cc127';
  const appKey = '65a2afc3ac9099090ae200ffab82b453';

  final url =
      'https://api.edamam.com/api/food-database/v2/parser?app_id=$appId&app_key=$appKey&ingr=$query';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List items = data['hints'];

    return items.map((item) {
      final food = item['food'];
      return FoodItem.fromJson(food);
    }).toList();
  } else {
    throw Exception('Failed to load food data');
  }
}