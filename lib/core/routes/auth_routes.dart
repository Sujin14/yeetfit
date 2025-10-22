import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/auth/presentation/screens/login_screen.dart';
import 'package:yeetfit/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:yeetfit/features/user_info/presentation/screens/user_info_step_page.dart';

import 'auth_route_constants.dart';

// Routes for authentication and user setup features.
List<GoRoute> get authRoutes => [
      GoRoute(
        path: AuthRouteConstants.root,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AuthRouteConstants.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AuthRouteConstants.userInfoStep,
        builder: (context, state) {
          final step = int.tryParse(state.pathParameters['step'] ?? '0') ?? 0;
          return UserInfoStepPage(step: step);
        },
      ),
    ];