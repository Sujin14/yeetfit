import 'package:flutter/material.dart';
import '../../data/models/plan_model.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class PlanListItem extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;

  const PlanListItem({super.key, required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: GlassCard(
        borderRadius: 20,
        color: colors.navAccent,
        opacity: 0.9,
        padding: EdgeInsets.zero,
        border: Border.all(color: colors.borderStart, width: 1.5),
        child: Center(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            title: Text(
              plan.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: colors.onBackground,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              plan.type == 'diet'
                  ? '${plan.details['meals']?.length ?? 0} meals'
                  : '${plan.details['exercises']?.length ?? 0} exercises',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: colors.textSecondary,
                fontSize: 14,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colors.onBackground,
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
