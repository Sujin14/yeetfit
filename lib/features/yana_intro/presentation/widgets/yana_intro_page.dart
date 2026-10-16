import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/full_screen_image_page.dart';
import 'yana_name_tag.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Full-screen Yana illustration with her line of speech over the bottom.
class YanaIntroPage extends StatelessWidget {
  final String imagePath;
  final String message;

  const YanaIntroPage({
    super.key,
    required this.imagePath,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return FullScreenImagePage(
      imagePath: imagePath,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const YanaNameTag(),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }
}
