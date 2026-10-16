import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_card_list.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// One placeholder per notification toggle.
class NotificationPreferencesShimmer extends StatelessWidget {
  final int count;

  const NotificationPreferencesShimmer({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: ShimmerCardList(
        count: count,
        height: 72,
        gap: 12,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
    );
  }
}
