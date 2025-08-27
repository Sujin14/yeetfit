import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class ContactUsBody extends StatelessWidget {
  const ContactUsBody({super.key});

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
            'Contact Us',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: FixedSizes.font24(context),
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          Text(
            'We’re here to help! Reach out to our support team for any questions or issues.',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          Text(
            'Contact Information',
            style: AppTheme.textStyles['subtitle']!.copyWith(
              fontSize: FixedSizes.font18(context),
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: FixedSizes.box8(context)),
          Text(
            'Email: support@oyeetfit.com\n'
            'Phone: +1-800-555-1234\n'
            'Address: 123 Fitness Lane, Health City, HC 12345',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ],
      ),
    );
  }
}
