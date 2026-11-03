import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/shared/widgets/chat_shimmer.dart';
import 'package:yeetfit/shared/widgets/shimmer_box.dart';
import 'package:yeetfit/shared/widgets/shimmer_wrapper.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';

/// Skeleton matching the coach chat screen (header + bubbles).
class CoachChatGateLoading extends StatelessWidget {
  const CoachChatGateLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.smd,
              AppSpacing.sm,
              AppSpacing.smd,
              AppSpacing.xs,
            ),
            child: ShimmerWrapper(
              child: Row(
                children: const [
                  YeetBackButton(),
                  SizedBox(width: AppSpacing.smd),
                  ShimmerBox(width: 40, height: 40, borderRadius: 20),
                  SizedBox(width: AppSpacing.smd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 120, height: 16, borderRadius: 8),
                        SizedBox(height: 6),
                        ShimmerBox(width: 64, height: 12, borderRadius: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(child: ChatShimmer()),
        ],
      ),
    );
  }
}
