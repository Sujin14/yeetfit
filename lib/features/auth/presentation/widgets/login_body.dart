import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/auth_route_constants.dart';
import 'auth_layout.dart';
import 'auth_redirect_prompt.dart';
import 'login_form.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      form: const LoginForm(),
      footer: AuthRedirectPrompt(
        message: "Don't have an account? ",
        actionLabel: 'Sign up',
        onPressed: () => context.go(AuthRouteConstants.signup),
      ),
    );
  }
}
