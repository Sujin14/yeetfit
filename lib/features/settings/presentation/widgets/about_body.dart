import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/shared/widgets/settings_tile.dart';
import 'about_header.dart';

class AboutBody extends StatelessWidget {
  final String versionLabel;
  final VoidCallback onPrivacyTap;
  final VoidCallback onTermsTap;

  const AboutBody({
    super.key,
    required this.versionLabel,
    required this.onPrivacyTap,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AboutHeader(versionLabel: versionLabel),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
          ),
          child: Divider(color: colors.textMuted.withValues(alpha: 0.4)),
        ),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          label: 'Privacy Policy',
          onTap: onPrivacyTap,
        ),
        SettingsTile(
          icon: Icons.description_outlined,
          label: 'Terms & Conditions',
          onTap: onTermsTap,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          '© 2026 YeetFit. All rights reserved.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: colors.textMuted),
        ),
      ],
    );
  }
}
