import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/recovery/presentation/screens/recovery_score_screen.dart';
import 'recovery_route_constants.dart';

// Routes for the recovery score feature, pushed above the shell.
List<GoRoute> get recoveryRoutes => [
  GoRoute(
    path: RecoveryRouteConstants.root,
    builder: (context, state) => const RecoveryScoreScreen(),
  ),
];
