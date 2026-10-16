import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/settings_route_constants.dart';
import 'package:yeetfit/shared/widgets/settings_tile.dart';
import 'settings_section_label.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    void open(String route) => context.push(route);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SettingsSectionLabel('Profile'),
        SettingsTile(
          icon: Icons.person_outline,
          label: 'Basic Information',
          onTap: () => open(SettingsRouteConstants.basicInformation),
        ),
        SettingsTile(
          icon: Icons.flag_outlined,
          label: 'Goal Settings',
          onTap: () => open(SettingsRouteConstants.goalSettings),
        ),
        SettingsTile(
          icon: Icons.restaurant_menu,
          label: 'Food Preferences',
          onTap: () => open(SettingsRouteConstants.foodPreferences),
        ),
        const SizedBox(height: AppSpacing.sm),
        const SettingsSectionLabel('App'),
        SettingsTile(
          icon: Icons.notifications_none_rounded,
          label: 'Notifications',
          onTap: () => open(SettingsRouteConstants.notifications),
        ),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          label: 'Privacy Policy',
          onTap: () => open(SettingsRouteConstants.privacyPolicy),
        ),
        SettingsTile(
          icon: Icons.description_outlined,
          label: 'Terms & Conditions',
          onTap: () => open(SettingsRouteConstants.termsAndConditions),
        ),
        const SizedBox(height: AppSpacing.sm),
        const SettingsSectionLabel('Support'),
        SettingsTile(
          icon: Icons.help_outline_rounded,
          label: 'Help & Support',
          onTap: () => open(SettingsRouteConstants.help),
        ),
        SettingsTile(
          icon: Icons.mail_outline_rounded,
          label: 'Contact Us',
          onTap: () => open(SettingsRouteConstants.contactUs),
        ),
        SettingsTile(
          icon: Icons.info_outline_rounded,
          label: 'About',
          onTap: () => open(SettingsRouteConstants.about),
        ),
        const SizedBox(height: AppSpacing.sm),
        const SettingsSectionLabel('Account'),
        SettingsTile(
          icon: Icons.manage_accounts_outlined,
          label: 'Account',
          onTap: () => open(SettingsRouteConstants.account),
        ),
      ],
    );
  }
}
