import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/auth_route_constants.dart';
import 'package:yeetfit/core/routes/onboarding_route_constants.dart';
import 'package:yeetfit/shared/widgets/auth_background.dart';
import '../widgets/welcome_body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: WelcomeBody(
          onGetStarted: () => context.push(OnboardingRouteConstants.onboarding),
          onSignIn: () => context.go(AuthRouteConstants.root),
        ),
      ),
    );
  }
}
