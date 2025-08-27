import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class TermsAndConditionsBody extends StatelessWidget {
  const TermsAndConditionsBody({super.key});

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
            'Terms & Conditions',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: FixedSizes.font24(context),
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          Text(
            'By using our app, you agree to the following terms and conditions:',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          Text(
            '1. Usage\n'
            'You agree to use the app for personal, non-commercial purposes only.\n\n'
            '2. Data Privacy\n'
            'We collect and store your personal information in accordance with our Privacy Policy.\n\n'
            '3. Account Responsibility\n'
            'You are responsible for maintaining the confidentiality of your account credentials.\n\n'
            '4. Termination\n'
            'We reserve the right to terminate your access to the app for violating these terms.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ],
      ),
    );
  }
}
