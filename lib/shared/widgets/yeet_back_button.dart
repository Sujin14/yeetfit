import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/shell_route_constants.dart';

/// Frosted circular back button used as the leading control on every pushed
/// screen.
class YeetBackButton extends StatelessWidget {
  /// Defaults to popping, or to the dashboard when there is nothing to pop
  /// (e.g. the screen was opened from a deep link).
  final VoidCallback? onTap;

  const YeetBackButton({super.key, this.onTap});

  static const double size = 40;

  /// AppBar `leadingWidth` that fits the button plus its left inset.
  static const double leadingWidth = 64;

  void _defaultBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(ShellRouteConstants.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Back',
      child: Semantics(
        button: true,
        label: 'Back',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap ?? () => _defaultBack(context),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
