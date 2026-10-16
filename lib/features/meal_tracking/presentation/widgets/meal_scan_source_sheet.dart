import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Camera / Gallery chooser. Pops with the selected [ImageSource].
class MealScanSourceSheet extends StatelessWidget {
  const MealScanSourceSheet({super.key});

  static Future<ImageSource?> show(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MealScanSourceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final labelStyle = Theme.of(
      context,
    ).textTheme.titleMedium!.copyWith(color: colors.onBackground);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          opacity: 0.16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.photo_camera_outlined,
                  color: colors.primary,
                ),
                title: Text('Camera', style: labelStyle),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: colors.secondary,
                ),
                title: Text('Gallery', style: labelStyle),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
