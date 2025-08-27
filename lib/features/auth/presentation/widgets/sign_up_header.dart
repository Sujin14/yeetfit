// sign_up_header.dart
import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: FixedSizes.box24(context),
        vertical: FixedSizes.box20(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              'Create Account',
              style: AppTheme.textStyles['heading']!.copyWith(
                fontSize: FixedSizes.fontHeading(context),
                color: AppTheme.colors['primaryText'],
              ),
              softWrap: false,
            ),
          ),
          SizedBox(height: FixedSizes.box8(context)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              'Join YeetFit to begin your fitness journey!',
              style: AppTheme.textStyles['subtitle']!.copyWith(
                fontSize: FixedSizes.fontSubtitle(context),
                color: AppTheme.colors['secondaryText'],
              ),
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
