import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../widgets/plan_list_screen_body.dart';

class PlanListScreen extends StatelessWidget {
  final String category;

  const PlanListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: category == 'diet' ? 'Diet Plans' : 'Workout Plans',
      ),
      body: PlanListScreenBody(category: category),
    );
  }
}
