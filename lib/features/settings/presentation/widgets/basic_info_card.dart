import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class BasicInfoCard extends StatelessWidget {
  final VoidCallback onTap;

  const BasicInfoCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: FixedSizes.box100(context),
        borderRadius: FixedSizes.radius16(context),
        blur: 10,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          colors: [
            AppTheme.colors['navigationAccent']!.withOpacity(0.1),
            AppTheme.colors['navigationAccent']!.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            AppTheme.colors['gradientTextStart']!,
            AppTheme.colors['gradientTextEnd']!,
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(FixedSizes.box16(context)),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Basic Information',
                    style: AppTheme.textStyles['subtitle']!.copyWith(
                      fontSize: FixedSizes.font18(context),
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  SizedBox(height: FixedSizes.box8(context)),
                  Text(
                    'Height, Weight, Age, Gender, Activity',
                    style: AppTheme.textStyles['body']!.copyWith(
                      fontSize: FixedSizes.font14(context),
                      color: AppTheme.colors['secondaryText'],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
