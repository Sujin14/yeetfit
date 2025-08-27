import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class AboutBody extends StatelessWidget {
  const AboutBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: FixedSizes.box24(context),
        vertical: FixedSizes.box24(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'About Our App',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: FixedSizes.font24(context),
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          Text(
            'Our app is designed to help you achieve your health and fitness goals through personalized tracking and insights. Set your fitness goals, customize your diet preferences, and track your progress with a user-friendly interface.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          Text(
            'Features',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: FixedSizes.font18(context),
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box8(context)),
          Text(
            '- Personalized fitness goal setting\n'
            '- Diet preference and allergy customization\n'
            '- Real-time progress monitoring\n'
            '- User-friendly interface',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ],
      ),
    );
  }
}
