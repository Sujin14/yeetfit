import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Guard for authentication-based redirects.
// Redirects unauthenticated users to login, excluding public paths.
class AuthRedirectGuard {
  static Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final user = FirebaseAuth.instance.currentUser;
    final currentPath = state.uri.toString();
    final publicPaths = ['/', '/login', '/signup', '/onboarding', '/welcome'];

    if (user == null && !publicPaths.contains(currentPath)) {
      return '/login';
    }
    return null;
  }
}