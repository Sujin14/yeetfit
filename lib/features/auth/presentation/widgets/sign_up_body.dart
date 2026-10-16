import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/auth_route_constants.dart';
import 'auth_layout.dart';
import 'auth_redirect_prompt.dart';
import 'sign_up_form.dart';

class SignUpBody extends StatelessWidget {
  const SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      form: const SignUpForm(),
      footer: AuthRedirectPrompt(
        message: 'Already have an account? ',
        actionLabel: 'Sign in',
        onPressed: () => context.go(AuthRouteConstants.root),
      ),
    );
  }
}
