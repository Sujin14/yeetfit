import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final String selectedGoal;
  final ValueChanged<String?>? onGoalSelected;
  final String unit;
  final Color color;

  const GoalCard({
    super.key,
    required this.title,
    required this.selectedGoal,
    this.onGoalSelected,
    this.unit = '',
    this.color = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onGoalSelected != null) onGoalSelected!(selectedGoal);
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FixedSizes.radius16(context)),
        ),
        child: Padding(
          padding: EdgeInsets.all(FixedSizes.box16(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: FixedSizes.font16(context),
                  color: AppTheme.colors['onSurfaceDark'],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: FixedSizes.box8(context)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    selectedGoal,
                    style: AppTheme.textStyles['titleMedium']!.copyWith(
                      fontSize: FixedSizes.font24(context),
                      color: AppTheme.colors['black'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (unit.isNotEmpty) ...[
                    SizedBox(width: FixedSizes.box4(context)),
                    Text(
                      unit,
                      style: AppTheme.textStyles['body']!.copyWith(
                        fontSize: FixedSizes.font14(context),
                        color: AppTheme.colors['onSurfaceDark'],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
