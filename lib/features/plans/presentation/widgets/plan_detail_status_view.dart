import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';

/// Loading / error / not-found layout for the plan detail page.
class PlanDetailStatusView extends StatelessWidget {
  final String title;
  final Widget child;

  const PlanDetailStatusView({
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
