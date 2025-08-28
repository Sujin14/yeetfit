import 'package:flutter/material.dart';
import '../widgets/plan_detail_screen_body.dart';

class PlanDetailPage extends StatelessWidget {
  final Map<String, dynamic> extra;

  const PlanDetailPage({super.key, required this.extra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlanDetailScreenBody(extra: extra),
    );
  }
}