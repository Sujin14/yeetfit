import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/yana_intro/presentation/screens/yana_intro_screen.dart';
import 'yana_intro_route_constants.dart';

// Route for the one-time Yana introduction shown before the dashboard.
List<GoRoute> get yanaIntroRoutes => [
  GoRoute(
    path: YanaIntroRouteConstants.intro,
    builder: (context, state) => const YanaIntroScreen(),
  ),
];
