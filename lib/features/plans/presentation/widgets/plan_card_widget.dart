import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class PlanCardWidget extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final VoidCallback onTap;

  const PlanCardWidget({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: FixedSizes.box200(context),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FixedSizes.borderRadius(context)),
        child: Padding(
          padding: EdgeInsets.all(FixedSizes.box16(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: FixedSizes.icon48(context),
                color: AppTheme.colors['primaryText'],
              ),
              SizedBox(height: FixedSizes.box8(context)),
              Text(
                title,
                style: AppTheme.textStyles['title']?.copyWith(
                  color: AppTheme.colors['primaryText'],
                  fontSize: FixedSizes.font20(context),
                ),
              ),
              SizedBox(height: FixedSizes.box4(context)),
              Text(
                '$count plan${count == 1 ? '' : 's'}',
                style: AppTheme.textStyles['body']?.copyWith(
                  color: AppTheme.colors['secondaryText'],
                  fontSize: FixedSizes.font16(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
