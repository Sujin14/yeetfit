import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/auth_route_constants.dart';
import '../widgets/onboarding_body.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: OnboardingBody(
        onFinish: () => context.go(AuthRouteConstants.signup),
      ),
    );
  }
}
