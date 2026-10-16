import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/onboarding_route_constants.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

// Default error screen for unmatched routes.
class ErrorScreen extends StatelessWidget {
  final String? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        leadingWidth: YeetBackButton.leadingWidth,
        leading: const Padding(
          padding: EdgeInsets.only(left: AppSpacing.md),
          child: Center(child: YeetBackButton()),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error ?? 'Page not found'),
            ElevatedButton(
              onPressed: () => context.go(OnboardingRouteConstants.splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// GoRoute for error handling.
GoRoute get errorRoute => GoRoute(
  path: '/404',
  builder: (context, state) => ErrorScreen(error: state.error?.toString()),
);
