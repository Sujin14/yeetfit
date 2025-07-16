import 'package:flutter/material.dart';

import '../widgets/food_list.dart';
import '../widgets/food_search_bar.dart';
import '../widgets/manual_add_button.dart';


class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Search Food',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            FoodSearchBar(),
            SizedBox(height: 12),
            FoodList(),
          ],
        ),
      ),
      floatingActionButton: const ManualAddButton(),
    );
  }
}