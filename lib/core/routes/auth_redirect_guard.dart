import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/user_info/data/datasources/profile_completion_status.dart';
import 'package:yeetfit/features/yana_intro/data/datasources/yana_intro_local_datasource.dart';
import 'auth_route_constants.dart';
import 'onboarding_route_constants.dart';
import 'shell_route_constants.dart';
import 'yana_intro_route_constants.dart';

// App-wide redirect, evaluated in order:
//   1. Signed out → login (pre-auth screens stay reachable).
//   2. Onboarding is the pre-auth carousel, so being signed in implies it.
//   3. Profile setup incomplete → user info steps.
//   4. Yana intro not yet shown for this account → /yana-intro.
//   5. Otherwise the requested route (e.g. the dashboard).
class AuthRedirectGuard {
  static const Set<String> _publicPaths = {
    OnboardingRouteConstants.splash,
    OnboardingRouteConstants.onboarding,
    OnboardingRouteConstants.welcome,
    AuthRouteConstants.root,
    AuthRouteConstants.signup,
  };

  static FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final user = FirebaseAuth.instance.currentUser;
    final location = state.matchedLocation;

    if (user == null) {
      return _publicPaths.contains(location) ? null : AuthRouteConstants.root;
    }
    // The splash, pre-auth screens and the setup flow navigate themselves.
    if (_publicPaths.contains(location) ||
        location.startsWith(AuthRouteConstants.userInfoStepPrefix)) {
      return null;
    }

    final uid = user.uid;
    final profileComplete = ProfileCompletionStatus.cachedComplete(uid);
    final introShown = YanaIntroLocalDataSource.cachedShown(uid);
    // Synchronous once both flags are cached, which is every navigation
    // after the first in a session.
    if (profileComplete != null && introShown != null) {
      return _resolve(location, profileComplete, introShown);
    }
    return _resolveAsync(uid, location);
  }

  /// Warms both caches (e.g. during the splash) so the first protected
  /// navigation doesn't wait on Firestore.
  static Future<void> prefetch(String uid) async {
    await Future.wait([
      ProfileCompletionStatus.isComplete(uid),
      YanaIntroLocalDataSource.isShown(uid),
    ]);
  }

  static Future<String?> _resolveAsync(String uid, String location) async {
    final profileComplete = await ProfileCompletionStatus.isComplete(uid);
    final introShown = await YanaIntroLocalDataSource.isShown(uid);
    return _resolve(location, profileComplete, introShown);
  }

  static String? _resolve(
    String location,
    bool profileComplete,
    bool introShown,
  ) {
    if (!profileComplete) return AuthRouteConstants.userInfoStepPath(0);
    if (location == YanaIntroRouteConstants.intro) {
      return introShown ? ShellRouteConstants.dashboard : null;
    }
    if (!introShown) return YanaIntroRouteConstants.intro;
    return null;
  }
}
