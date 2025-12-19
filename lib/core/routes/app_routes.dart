import 'package:go_router/go_router.dart';
import 'auth_redirect_guard.dart';
import 'auth_routes.dart';
import 'chat_routes.dart';
import 'error_route.dart';
import 'onboarding_routes.dart';
import 'plans_route.dart';
import 'settings_routes.dart';
import 'shell_routes.dart';
import 'tracking_routes.dart';

// Main app router configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const ErrorScreen(),
  redirect: AuthRedirectGuard.redirect,
  routes: [
    ...onboardingRoutes,
    ...authRoutes,
    shellRoute, // Main shell with bottom nav.
    ...plansRoutes,
    ...trackingRoutes,
    ...settingsRoutes,
    ...chatRoutes,
    errorRoute,
  ],
);