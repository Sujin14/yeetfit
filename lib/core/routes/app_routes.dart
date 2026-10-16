import 'package:go_router/go_router.dart';
import 'auth_redirect_guard.dart';
import 'auth_routes.dart';
import 'call_routes.dart';
import 'challenge_routes.dart';
import 'chat_routes.dart';
import 'coach_routes.dart';
import 'error_route.dart';
import 'onboarding_routes.dart';
import 'plans_route.dart';
import 'recovery_routes.dart';
import 'session_routes.dart';
import 'settings_routes.dart';
import 'shell_routes.dart';
import 'tracking_routes.dart';
import 'yana_intro_routes.dart';

// Main app router configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const ErrorScreen(),
  redirect: AuthRedirectGuard.redirect,
  routes: [
    ...onboardingRoutes,
    ...authRoutes,
    ...yanaIntroRoutes,
    shellRoute, // Main shell with bottom nav.
    ...plansRoutes,
    ...trackingRoutes,
    ...settingsRoutes,
    ...chatRoutes,
    ...coachRoutes,
    ...recoveryRoutes,
    ...challengeRoutes,
    ...callRoutes,
    ...sessionRoutes,
    errorRoute,
  ],
);
