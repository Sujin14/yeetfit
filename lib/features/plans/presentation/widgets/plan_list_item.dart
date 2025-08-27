import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../data/models/plan_model.dart';
import 'package:glassmorphism/glassmorphism.dart';

class PlanListItem extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;

  const PlanListItem({super.key, required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: FixedSizes.box100(context),
      borderRadius: FixedSizes.borderRadius(context),
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.colors['navigationAccent']!,
          AppTheme.colors['navigationAccent']!.withOpacity(0.8),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['borderGradientStart']!,
          AppTheme.colors['borderGradientEnd']!,
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: FixedSizes.box16(context),
          vertical: FixedSizes.box8(context),
        ),
        title: Text(
          plan.title,
          style: AppTheme.textStyles['title']?.copyWith(
            color: AppTheme.colors['primaryText'],
            fontSize: FixedSizes.font18(context),
          ),
        ),
        subtitle: Text(
          plan.type == 'diet'
              ? '${plan.details['meals']?.length ?? 0} meals'
              : '${plan.details['exercises']?.length ?? 0} exercises',
          style: AppTheme.textStyles['body']?.copyWith(
            color: AppTheme.colors['secondaryText'],
            fontSize: FixedSizes.font14(context),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: FixedSizes.icon16(context),
          color: AppTheme.colors['primaryText'],
        ),
        onTap: onTap,
      ),
    );
  }
}
