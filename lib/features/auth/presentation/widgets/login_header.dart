// login_header.dart
import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: FixedSizes.box24(context),
        vertical: FixedSizes.box20(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  'Welcome Back',
                  style: AppTheme.textStyles['heading']!.copyWith(
                    fontSize: FixedSizes.fontHeading(context),
                    color: AppTheme.colors['primaryText'],
                  ),
                  softWrap: false,
                ),
              ),
              SizedBox(height: FixedSizes.box8(context)),
              Text(
                'Login to your account',
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: FixedSizes.fontSubtitle(context),
                  color: AppTheme.colors['secondaryText'],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
