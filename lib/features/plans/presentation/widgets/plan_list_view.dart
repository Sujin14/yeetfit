import 'package:flutter/material.dart';
import '../../data/models/plan_model.dart';
import 'plan_list_item.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class PlanListView extends StatelessWidget {
  final List<PlanModel> plans;
  final ValueChanged<PlanModel> onPlanTap;

  const PlanListView({super.key, required this.plans, required this.onPlanTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: PlanListItem(plan: plan, onTap: () => onPlanTap(plan)),
        );
      },
    );
  }
}
