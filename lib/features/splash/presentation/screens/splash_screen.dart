import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/providers/call_launch_providers.dart';
import 'package:yeetfit/core/routes/auth_redirect_guard.dart';
import 'package:yeetfit/core/routes/call_route_constants.dart';
import 'package:yeetfit/core/routes/onboarding_route_constants.dart';
import 'package:yeetfit/core/routes/shell_route_constants.dart';

import '../widgets/splash_background_image.dart';
import '../widgets/splash_body.dart';
import '../widgets/splash_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  /// Signed-in user lookup. Widget tests pass a stub so the splash can render
  /// without Firebase; production leaves this unset.
  final User? Function()? readCurrentUser;

  const SplashScreen({super.key, this.readCurrentUser});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  static const Duration _maxPrecacheWait = Duration(milliseconds: 800);

  late final AnimationController _backgroundController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final AnimationController _logoController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final AnimationController _textController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  late final Animation<double> _backgroundOpacity = CurvedAnimation(
    parent: _backgroundController,
    curve: Curves.easeIn,
  );
  late final Animation<double> _logoScale = Tween<double>(
    begin: 0.3,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
  late final Animation<double> _textOpacity = CurvedAnimation(
    parent: _textController,
    curve: Curves.easeOut,
  );
  late final Animation<Offset> _textSlide = Tween<Offset>(
    begin: const Offset(0, 0.3),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final uid = _signedInUser()?.uid;
    if (uid != null) unawaited(AuthRedirectGuard.prefetch(uid));
    unawaited(_precacheThenAnimate());
  }

  /// Decodes both images before the first frame of animation so neither pops
  /// in mid-fade; capped so a slow decode never stalls the splash.
  Future<void> _precacheThenAnimate() async {
    // Cold-start accept: skip the long splash and open the joining hold screen.
    if (widget.readCurrentUser == null) {
      final pendingCallId = ref.read(pendingAcceptedCallIdProvider);
      if (pendingCallId != null && pendingCallId.isNotEmpty) {
        if (mounted) _navigate();
        return;
      }
    }
    if (!mounted) return;
    final precache = Future.wait([
      precacheImage(SplashBackgroundImage.image, context),
      precacheImage(SplashLogo.image, context),
    ]);
    await precache.timeout(_maxPrecacheWait, onTimeout: () => const []);
    if (mounted) await _runAnimations();
  }

  Future<void> _runAnimations() async {
    _backgroundController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _logoController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _textController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (mounted) _navigate();
  }

  // AuthRedirectGuard diverts signed-in users with unfinished setup or an
  // unseen Yana intro on the way to the dashboard.
  void _navigate() {
    final pendingCallId = ref.read(pendingAcceptedCallIdProvider);
    if (pendingCallId != null && pendingCallId.isNotEmpty) {
      context.go(CallRouteConstants.joiningCallPath(pendingCallId));
      return;
    }

    final user = _signedInUser();
    context.go(
      user != null
          ? ShellRouteConstants.dashboard
          : OnboardingRouteConstants.welcome,
    );
  }

  User? _signedInUser() {
    final readCurrentUser = widget.readCurrentUser;
    if (readCurrentUser != null) return readCurrentUser();
    return FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SplashBody(
        backgroundOpacity: _backgroundOpacity,
        logoScale: _logoScale,
        textOpacity: _textOpacity,
        textSlide: _textSlide,
      ),
    );
  }
}
