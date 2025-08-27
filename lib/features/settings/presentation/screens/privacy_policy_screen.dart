import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double paddingH = FixedSizes.box24(context);
    final double paddingV = FixedSizes.box24(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: AppTheme.textStyles['title']!.copyWith(
            color: AppTheme.colors['primaryText'],
            fontSize: FixedSizes.font18(context),
          ),
        ),
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Privacy Policy',
              style: AppTheme.textStyles['subtitle']!.copyWith(
                fontSize: FixedSizes.font22(context),
                color: AppTheme.colors['primaryText'],
              ),
            ),
            SizedBox(height: FixedSizes.box16(context)),
            Text(
              'Your privacy is important to us. This policy explains how we collect, use, and protect your personal information.',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['primaryText'],
                fontSize: FixedSizes.font14(context),
              ),
            ),
            SizedBox(height: FixedSizes.box16(context)),
            Text(
              '1. Data Collection\n'
              'We collect personal information such as your name, email, and health data to provide personalized services.\n\n'
              '2. Data Usage\n'
              'Your data is used to track your progress, provide insights, and improve our services.\n\n'
              '3. Data Protection\n'
              'We implement security measures to protect your information from unauthorized access.\n\n'
              '4. Data Sharing\n'
              'We do not share your personal information with third parties without your consent, except as required by law.',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
                fontSize: FixedSizes.font14(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
