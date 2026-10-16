import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/coaches/domain/entities/coach.dart';
import 'package:yeetfit/features/coaches/presentation/screens/coach_detail_screen.dart';
import 'coach_route_constants.dart';
import 'shell_route_constants.dart';

// Coach detail, pushed above the shell. The list itself is a shell tab.
List<GoRoute> get coachRoutes => [
  GoRoute(
    path: CoachRouteConstants.detail,
    redirect: (context, state) =>
        state.extra is Coach ? null : ShellRouteConstants.coaches,
    builder: (context, state) => CoachDetailScreen(coach: state.extra as Coach),
  ),
];
