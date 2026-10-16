import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_card_list.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Six settings-row placeholders.
class SettingsShimmer extends StatelessWidget {
  const SettingsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: ShimmerCardList(count: 6, height: 56, gap: 4),
    );
  }
}
