import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yeetfit/core/constants/legal_constants.dart';
import 'package:yeetfit/core/utils/url_utils.dart';
import 'package:yeetfit/shared/widgets/settings_tile.dart';

import 'settings_section_label.dart';

/// Terms and privacy rows. Each opens the hosted document in the browser.
class SettingsLegalSection extends StatelessWidget {
  const SettingsLegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SettingsSectionLabel('Legal'),
        SettingsTile(
          icon: Icons.description_outlined,
          label: 'Terms & Conditions',
          trailingIcon: Icons.open_in_new,
          onTap: () => _open(context, kTermsUrl),
        ),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          label: 'Privacy Policy',
          trailingIcon: Icons.open_in_new,
          onTap: () => _open(context, kPrivacyUrl),
        ),
      ],
    );
  }

  void _open(BuildContext context, String url) {
    unawaited(_openUrl(context, url));
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      await launchUrlExternal(url);
    } catch (error) {
      debugPrint('Opening $url failed: $error');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the link')),
      );
    }
  }
}
