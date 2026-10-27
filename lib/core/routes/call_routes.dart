import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/calls/domain/entities/call_session.dart';
import 'package:yeetfit/features/calls/presentation/screens/active_call_screen.dart';
import 'package:yeetfit/features/calls/presentation/screens/call_setup_screen.dart';
import 'package:yeetfit/features/calls/presentation/screens/joining_call_screen.dart';
import 'call_route_constants.dart';
import 'shell_route_constants.dart';

// Active call needs the session as `extra`. Joining-call only needs the path
// id (cold-start accept). Native IncomingCallActivity owns the ringing UI.
List<GoRoute> get callRoutes => [
  GoRoute(
    path: CallRouteConstants.activeCall,
    redirect: (context, state) =>
        state.extra is CallSession ? null : ShellRouteConstants.dashboard,
    builder: (context, state) =>
        ActiveCallScreen(call: state.extra as CallSession),
  ),
  GoRoute(
    path: CallRouteConstants.joiningCall,
    builder: (context, state) =>
        JoiningCallScreen(callId: state.pathParameters['callId']!),
  ),
  GoRoute(
    path: CallRouteConstants.callSetup,
    builder: (context, state) => const CallSetupScreen(),
  ),
];
