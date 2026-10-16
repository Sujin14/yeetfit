import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/shared/widgets/logo_section.dart';

/// Wordmark, then the [form] and [footer] a short way below it, directly on
/// the auth background. Spare room sits under the footer and shrinks when
/// the keyboard opens; the page scrolls on a short screen.
class AuthLayout extends StatelessWidget {
  static const double _headingTopPadding = AppSpacing.xxl * 3;

  final Widget form;
  final Widget footer;

  const AuthLayout({super.key, required this.form, required this.footer});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const LogoSection(
                  topPadding: _headingTopPadding,
                  showLogo: false,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: form,
                ),
                footer,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
