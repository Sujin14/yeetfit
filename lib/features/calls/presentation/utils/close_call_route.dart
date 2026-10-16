import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/shell_route_constants.dart';

/// Leaves a call screen once, however many status updates or button taps
/// ask for it, optionally explaining why.
void closeCallRoute(BuildContext context, {String? message}) {
  final route = ModalRoute.of(context);
  if (route == null || !route.isCurrent) return;
  if (message != null) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(ShellRouteConstants.dashboard);
  }
}
