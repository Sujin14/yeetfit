import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Camera or gallery choice for a new profile photo.
class ProfilePhotoSourceSheet extends StatelessWidget {
  const ProfilePhotoSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.bodyLarge!.copyWith(
      color: colors.onBackground,
    );

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            leading: Icon(Icons.camera_alt_outlined, color: colors.primary),
            title: Text('Take Photo', style: titleStyle),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.photo_library_outlined, color: colors.primary),
            title: Text('Choose from Gallery', style: titleStyle),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
