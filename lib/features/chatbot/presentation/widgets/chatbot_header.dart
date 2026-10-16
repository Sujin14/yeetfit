import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';
import 'package:yeetfit/shared/widgets/yana_avatar.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Back pill, "Yana / Your fitness coach" title and Yana's avatar.
class ChatbotHeader extends StatelessWidget {
  /// Forces light text when drawn over the empty-chat image.
  final bool overImage;

  const ChatbotHeader({super.key, this.overImage = false});

  static const double _avatarSize = 44;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final titleColor = overImage ? Colors.white : colors.onBackground;
    final subtitleColor = overImage
        ? Colors.white.withValues(alpha: 0.7)
        : colors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.smd,
      ),
      child: Row(
        children: [
          // Back button slot matches the avatar width, keeping the title centred.
          const SizedBox(
            width: _avatarSize,
            child: Align(
              alignment: Alignment.centerLeft,
              child: YeetBackButton(),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Yana',
                  style: textTheme.titleLarge!.copyWith(color: titleColor),
                ),
                Text(
                  'Your fitness coach',
                  style: textTheme.bodySmall!.copyWith(color: subtitleColor),
                ),
              ],
            ),
          ),
          const YanaAvatar(size: _avatarSize),
        ],
      ),
    );
  }
}
