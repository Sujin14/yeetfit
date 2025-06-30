import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';

class SignupRedirect extends StatelessWidget {
  const SignupRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/signup'),
      child: Text(
        "Don't have an account? Sign up",
        style: AppTheme.textStyles['body']!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
