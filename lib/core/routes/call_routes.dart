import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/calls/domain/entities/call_session.dart';
import 'package:yeetfit/features/calls/presentation/screens/active_call_screen.dart';
import 'package:yeetfit/features/calls/presentation/screens/incoming_call_screen.dart';
import 'call_route_constants.dart';
import 'shell_route_constants.dart';

// 1-to-1 coach call routes, pushed above the shell. Both need the call
// passed as `extra`; deep links without it fall back to the dashboard.
List<GoRoute> get callRoutes => [
  GoRoute(
    path: CallRouteConstants.activeCall,
    redirect: (context, state) =>
        state.extra is CallSession ? null : ShellRouteConstants.dashboard,
    builder: (context, state) =>
        ActiveCallScreen(call: state.extra as CallSession),
  ),
  GoRoute(
    path: CallRouteConstants.incomingCall,
    redirect: (context, state) =>
        state.extra is CallSession ? null : ShellRouteConstants.dashboard,
    builder: (context, state) =>
        IncomingCallScreen(call: state.extra as CallSession),
  ),
];
