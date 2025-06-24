import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/onboarding/presentation/onboarding/providers/onboarding_screen.dart';
import 'package:yeetfit/features/splash_screen.dart';
import '../../features/auth/admin/presentation/screens/admin_login_screen.dart';
import '../../features/auth/user/login/presentation/screens/login_screen.dart';
import '../../features/auth/user/signup/presentation/screens/sign_up_screen.dart';
import '../../features/dashboard/presentation/admin_dashboard_screen.dart';
import '../../features/dashboard/presentation/user_dashboard_screen.dart';
import '../../features/welcome/pages/welcome_screen.dart';

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
      path: '/admin-login',
      builder: (context, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: '/user-dashboard',
      builder: (context, state) => const UserDashboard(),
    ),
    GoRoute(
      path: '/admin-dashboard',
      builder: (context, state) => const AdminDashboard(),
    ),
  ],
);
