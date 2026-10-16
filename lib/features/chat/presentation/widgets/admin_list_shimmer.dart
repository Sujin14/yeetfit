import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_card_list.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Coach-row placeholders.
class AdminListShimmer extends StatelessWidget {
  const AdminListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ShimmerCardList(count: 4, height: 72),
    );
  }
}
