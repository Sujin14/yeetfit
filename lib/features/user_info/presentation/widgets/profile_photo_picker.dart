import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/button_spinner.dart';

class ProfilePhotoPicker extends StatelessWidget {
  static const double _radius = 48;

  final String? localImagePath;
  final String? networkImageUrl;
  final bool isUploading;
  final VoidCallback onTap;

  const ProfilePhotoPicker({
    super.key,
    required this.onTap,
    this.localImagePath,
    this.networkImageUrl,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final ImageProvider? image = localImagePath != null
        ? FileImage(File(localImagePath!))
        : networkImageUrl != null
        ? NetworkImage(networkImageUrl!)
        : null;

    return Semantics(
      button: true,
      label: 'Choose profile photo',
      child: GestureDetector(
        onTap: isUploading ? null : onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.primary, colors.secondary],
                ),
              ),
              child: CircleAvatar(
                radius: _radius,
                backgroundColor: colors.surface,
                backgroundImage: image,
                child: image == null
                    ? Icon(
                        Icons.add_a_photo_outlined,
                        size: 32,
                        color: colors.textSecondary,
                      )
                    : null,
              ),
            ),
            if (isUploading) ButtonSpinner(color: colors.primary),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                  border: Border.all(color: colors.surface, width: 2),
                ),
                child: Icon(Icons.edit, size: 14, color: colors.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
