import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/features/settings/presentation/providers/settings_provider.dart';
import 'package:yeetfit/shared/widgets/profile_photo_source_sheet.dart';

/// Camera or gallery, then a square crop, then save the photo on the profile.
/// Does nothing when the user cancels.
Future<void> pickAndCropProfileImage(BuildContext context) async {
  final colors = Theme.of(context).extension<AppColors>()!;
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    useRootNavigator: true,
    backgroundColor: colors.surface,
    builder: (_) => const ProfilePhotoSourceSheet(),
  );
  if (source == null || !context.mounted) return;

  final picked = await ImagePicker().pickImage(
    source: source,
    imageQuality: 85,
  );
  if (picked == null || !context.mounted) return;

  final cropped = await ImageCropper().cropImage(
    sourcePath: picked.path,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Photo',
        toolbarColor: colors.primary,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      IOSUiSettings(title: 'Crop Photo', aspectRatioLockEnabled: true),
    ],
  );
  if (cropped == null || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  try {
    await ProviderScope.containerOf(context)
        .read(settingsControllerProvider.notifier)
        .saveCroppedProfilePhoto(XFile(cropped.path));
    messenger.showSnackBar(
      const SnackBar(content: Text('Profile photo updated')),
    );
  } catch (error) {
    debugPrint('Profile photo update failed: $error');
    messenger.showSnackBar(
      const SnackBar(content: Text('Failed to update photo')),
    );
  }
}
