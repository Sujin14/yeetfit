import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class HelpBody extends StatelessWidget {
  const HelpBody({super.key});

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
            'Help & Support',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: FixedSizes.font24(context),
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          Text(
            'Need assistance? Here are some common questions and answers to help you get started.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          Text(
            'FAQs',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: FixedSizes.font18(context),
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box8(context)),
          Text(
            'Q: How do I update my profile?\n'
            'A: Go to Settings > Account > Basic Information to update your profile details.\n\n'
            'Q: How do I set my fitness goals?\n'
            'A: Navigate to Settings > Account > Goal Settings to set your fitness goals.\n\n'
            'Q: How do I contact support?\n'
            'A: Email us at support@oyeetfit.com for assistance.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ],
      ),
    );
  }
}
