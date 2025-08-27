import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../widgets/about_card.dart';
import '../widgets/help_card.dart';
import '../widgets/terms_and_conditions_card.dart';
import '../widgets/contact_us_card.dart';
import '../widgets/privacy_policy_card.dart';
import '../widgets/account_card.dart';
import '../providers/settings_provider.dart';

class SettingsBody extends ConsumerWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaving = ref.watch(settingsControllerProvider.notifier).isSaving;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: FixedSizes.box24(context),
        vertical: FixedSizes.box24(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassmorphicContainer(
            width: double.infinity,
            height: FixedSizes.box620(context),
            borderRadius: FixedSizes.radius16(context),
            blur: 10,
            alignment: Alignment.center,
            border: 1.5,
            linearGradient: LinearGradient(
              colors: [
                AppTheme.colors['navigationAccent']!.withOpacity(0.1),
                AppTheme.colors['navigationAccent']!.withOpacity(0.05),
              ],
            ),
            borderGradient: LinearGradient(
              colors: [
                AppTheme.colors['gradientTextStart']!,
                AppTheme.colors['gradientTextEnd']!,
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(FixedSizes.box16(context)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AboutCard(onTap: () => context.push('/about')),
                    HelpCard(onTap: () => context.push('/help')),
                    TermsAndConditionsCard(onTap: () => context.push('/terms-and-conditions')),
                    ContactUsCard(onTap: () => context.push('/contact-us')),
                    PrivacyPolicyCard(onTap: () => context.push('/privacy-policy')),
                    AccountCard(
                      onAccountTap: () => context.push('/account'),
                      onDeleteTap: () => ref.read(settingsControllerProvider.notifier).deleteAccount(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: FixedSizes.box24(context)),
          ElevatedButton(
            onPressed: isSaving ? null : () => ref.read(settingsControllerProvider.notifier).logout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['error'],
              minimumSize: Size(double.infinity, FixedSizes.box48(context)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FixedSizes.radius8(context)),
              ),
            ),
            child: isSaving
                ? SizedBox(
                    width: FixedSizes.box24(context),
                    height: FixedSizes.box24(context),
                    child: CircularProgressIndicator(
                      color: AppTheme.colors['onSurfaceDark'],
                    ),
                  )
                : Text(
                    'Logout',
                    style: AppTheme.textStyles['body']!.copyWith(
                      color: AppTheme.colors['onSurfaceDark'],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          SizedBox(height: FixedSizes.box24(context)),
          Center(
            child: Text(
              'App Version: 1.0.0',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
