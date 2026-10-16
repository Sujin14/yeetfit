import 'package:flutter/material.dart';

/// Fade + slight upward slide route for imperative `Navigator.push` calls.
/// GoRouter screens get the same transition through
/// `AppPageTransitionsBuilder` in the theme.
class AppPageRoute<T> extends PageRouteBuilder<T> {
  static const Duration duration = Duration(milliseconds: 250);

  static final Animatable<double> _fade = CurveTween(curve: Curves.easeOut);
  static final Animatable<Offset> _slide = Tween(
    begin: const Offset(0, 0.03),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeOut));

  AppPageRoute({
    required WidgetBuilder builder,
    super.settings,
    super.fullscreenDialog,
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         pageBuilder: (context, _, _) => builder(context),
         transitionsBuilder: (context, animation, _, child) =>
             buildTransition(animation, child),
       );

  static Widget buildTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation.drive(_fade),
      child: SlideTransition(position: animation.drive(_slide), child: child),
    );
  }
}
