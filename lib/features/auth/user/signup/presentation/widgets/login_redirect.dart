import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../shared/theme/app_text_styles.dart';

class SignInRedirect extends StatelessWidget {
  const SignInRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/login'),
      child: Text(
        "Already having an account? Sign in",
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
