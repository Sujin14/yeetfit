import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Gradient + glass app bar + scrolling content shared by every settings
/// screen (they're pushed routes outside the shell).
class SettingsPageLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const SettingsPageLayout({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            GlassSliverAppBar(title: title),
            SliverToBoxAdapter(child: child),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }
}
