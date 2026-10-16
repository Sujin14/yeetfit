import 'package:flutter/material.dart';
import 'shimmer_box.dart';
import 'shimmer_wrapper.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Alternating incoming/outgoing bubble placeholders, shared by the Yana and
/// coach chats.
class ChatShimmer extends StatelessWidget {
  const ChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smd,
        ),
        child: Column(
          children: [
            for (var i = 0; i < 3; i++) ...const [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ShimmerBox(width: 200, height: 44, borderRadius: 18),
                ],
              ),
              SizedBox(height: AppSpacing.smd),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShimmerBox(width: 160, height: 44, borderRadius: 18),
                ],
              ),
              SizedBox(height: AppSpacing.smd),
            ],
          ],
        ),
      ),
    );
  }
}
