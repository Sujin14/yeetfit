// New: Shared navigation logic for authentication.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/auth_route_constants.dart';
import '../../../core/routes/shell_route_constants.dart';
import '../domain/entities/auth_result.dart';

void handleAuthResult(BuildContext context, AuthResult result, String failureMessage) {
  if (!result.success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.message ?? failureMessage)),
    );
    return;
  }

  final exists = result.userExists;
  if (exists == true) {
    context.go(ShellRouteConstants.dashboard);
  } else {
    context.go(AuthRouteConstants.userInfoStep.replaceAll(':step', '0'));
  }
}