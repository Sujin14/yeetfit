import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/explore/presentation/screens/explore_screen.dart';
import 'package:yeetfit/features/progress/presentation/screens/progress_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/settings_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/user_info/presentation/screens/user_info_step_page.dart';
import '../../features/dashboard/presentation/screens/user_dashboard_screen.dart';
import '../../features/welcome/presentation/screens/welcome_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/user-dashboard',
      builder: (context, state) => const UserDashboard(),
    ),
    GoRoute(
      path: '/explore',
      builder: (context, state) => const ExploreScreen(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/user-info-step/:step',
      builder: (context, state) {
        final step = int.tryParse(state.pathParameters['step'] ?? '0') ?? 0;
        return UserInfoStepPage(step: step);
      },
    ),
  ],
);
