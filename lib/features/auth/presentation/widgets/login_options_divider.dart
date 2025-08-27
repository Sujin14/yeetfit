// login_options_divider.dart
import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class LoginOptionsDivider extends StatelessWidget {
  const LoginOptionsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: FixedSizes.box16(context)),
          child: Text(
            "or continue with",
            style: AppTheme.textStyles['body']!.copyWith(
              fontSize: FixedSizes.fontSmall(context),
              color: AppTheme.colors['secondaryText'],
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
