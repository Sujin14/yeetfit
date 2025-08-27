// sign_in_redirect.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class SignInRedirect extends StatelessWidget {
  const SignInRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/login'),
      child: Text(
        "Already have an account? Sign in",
        style: AppTheme.textStyles['body']!.copyWith(
          fontSize: FixedSizes.fontSmall(context),
          fontWeight: FontWeight.bold,
          color: AppTheme.colors['primaryAccent'],
        ),
      ),
    );
  }
}
