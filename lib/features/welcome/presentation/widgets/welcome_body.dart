import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/logo_section.dart';
import 'welcome_actions.dart';

class WelcomeBody extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  const WelcomeBody({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
            child: child,
          ),
        ),
        child: Column(
          children: [
            const Expanded(child: Center(child: LogoSection(topPadding: 0))),
            WelcomeActions(onGetStarted: onGetStarted, onSignIn: onSignIn),
          ],
        ),
      ),
    );
  }
}
