import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:yeetfit/features/splash/presentation/screens/splash_screen.dart';
import 'package:yeetfit/features/welcome/presentation/screens/welcome_screen.dart';
import 'onboarding_route_constants.dart';

// Routes for splash, onboarding, and welcome features.
List<GoRoute> get onboardingRoutes => [
  GoRoute(
    path: OnboardingRouteConstants.splash,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: OnboardingRouteConstants.onboarding,
    builder: (context, state) => const OnboardingScreen(),
  ),
  GoRoute(
    path: OnboardingRouteConstants.welcome,
    builder: (context, state) => const WelcomeScreen(),
  ),
];
