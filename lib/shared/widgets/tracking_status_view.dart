import 'package:flutter/material.dart';
import 'glass_sliver_app_bar.dart';

/// Glass app bar (with back button) over a loading or error [child], so a
/// tracking screen stays navigable before its data arrives.
class TrackingStatusView extends StatelessWidget {
  final String title;
  final Widget child;

  const TrackingStatusView({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        GlassSliverAppBar(title: title),
        SliverFillRemaining(hasScrollBody: false, child: child),
      ],
    );
  }
}
