import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yeetfit/core/theme/app_theme.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';

/// Full-screen artwork behind the welcome, login and sign-up screens. It
/// wraps the page's Scaffold, so the keyboard insets the Scaffold applies to
/// its body never move or resize it.
class AuthBackground extends StatelessWidget {
  static const String _imagePath = 'assets/images/auth_bg.webp';

  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // The photo is dark in either system theme, so the content always uses
    // the dark palette to stay legible on top of it.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Theme(
        data: AppTheme.dark(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Shows while the image decodes, or if it fails to load.
            const ShellGradientBackground(child: SizedBox.expand()),
            Image.asset(_imagePath, fit: BoxFit.cover),
            child,
          ],
        ),
      ),
    );
  }
}
