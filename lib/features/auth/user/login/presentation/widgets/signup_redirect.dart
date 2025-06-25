import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../shared/theme/app_text_styles.dart';

class SignupRedirect extends StatelessWidget {
  const SignupRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/signup'),
      child: Text(
        "Don't have an account? Sign up",
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
