import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/plans/presentation/screens/favorites_page.dart';
import '../../features/plans/presentation/screens/plan_detail_page.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/user_info/presentation/screens/user_info_step_page.dart';
import '../../features/welcome/presentation/screens/welcome_screen.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../shared/widgets/custom_appbar.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) async {
    final user = FirebaseAuth.instance.currentUser;
    final currentPath = state.uri.toString();
    if (user == null &&
        currentPath != '/' &&
        currentPath != '/login' &&
        currentPath != '/signup') {
      return '/login';
    }
    return null;
  },
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
    GoRoute(
      path: '/plans/:id',
      builder: (context, state) =>
          PlanDetailPage(extra: state.extra as Map<String, dynamic>),
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
              path: '/favorites',
              builder: (context, state) => const FavoritesPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
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
        showSettings: true,
        onSettings: () => context.push('/settings'),
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
        return 'Favorites';
      default:
        return '';
    }
  }
}
