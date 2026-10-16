import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/auth_route_constants.dart';
import '../../../core/routes/shell_route_constants.dart';
import '../domain/entities/auth_result.dart';

void handleAuthResult(
  BuildContext context,
  AuthResult result,
  String failureMessage,
) {
  if (!result.success) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message ?? failureMessage)));
    return;
  }

  context.go(
    result.userExists == true
        ? ShellRouteConstants.dashboard
        : AuthRouteConstants.userInfoStepPath(0),
  );
}
