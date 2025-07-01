import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yeetfit/features/explore/presentation/screens/explore_screen.dart';
import 'package:yeetfit/features/progress/presentation/screens/progress_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/settings_screen.dart';
import 'package:yeetfit/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:yeetfit/features/splash/presentation/screens/splash_screen.dart';
import 'package:yeetfit/features/auth/presentation/screens/login_screen.dart';
import 'package:yeetfit/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:yeetfit/features/user_info/presentation/screens/user_info_step_page.dart';
import 'package:yeetfit/shared/widgets/bottom_nav_bar.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/welcome/presentation/screens/welcome_screen.dart';
import '../../shared/widgets/custom_appbar.dart';

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
      path: '/user-info-step/:step',
      builder: (context, state) {
        final step = int.tryParse(state.pathParameters['step'] ?? '0') ?? 0;
        return UserInfoStepPage(step: step);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/user-dashboard',
              builder: (context, state) => const DashboardBody(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExploreScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class ShellScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({super.key, required this.navigationShell});

  @override
  State<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<ShellScaffold> {
  int _currentIndex = 0;

  void _onIndexChanged(int index) {
    if (index != 2) {
      setState(() {
        _currentIndex = index;
      });
      widget.navigationShell.goBranch(index > 2 ? index - 1 : index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _getTitle(_currentIndex),
        showLogout: _currentIndex == 0,
        onLogout: () async {
          await FirebaseAuth.instance.signOut();
          context.go('/');
        },
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widget.navigationShell,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        isVisible: true,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'YeetFit Dashboard';
      case 1:
        return 'Explore';
      case 3:
        return 'Progress';
      case 4:
        return 'Settings';
      default:
        return '';
    }
  }
}
