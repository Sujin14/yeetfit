import 'package:flutter/material.dart';
import 'app_page_route.dart';

/// Applies [AppPageRoute]'s transition and duration to theme-driven routes,
/// such as GoRouter's default pages.
class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppPageTransitionsBuilder();

  @override
  Duration get transitionDuration => AppPageRoute.duration;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AppPageRoute.buildTransition(animation, child);
  }
}
