import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/sessions/presentation/screens/create_session_screen.dart';
import 'session_route_constants.dart';

// Group training session routes, pushed above the shell.
List<GoRoute> get sessionRoutes => [
  GoRoute(
    path: SessionRouteConstants.create,
    builder: (context, state) => const CreateSessionScreen(),
  ),
];
