import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/profile/pick_and_crop_profile_image.dart';
import 'package:yeetfit/shared/widgets/settings_tile.dart';
import 'package:yeetfit/shared/widgets/yeet_confirm_dialog.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../../user_info/presentation/providers/user_info_provider.dart';
import '../providers/settings_provider.dart';
import 'account_header_card.dart';
import 'settings_section_label.dart';
import 'settings_shimmer.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class AccountBody extends ConsumerWidget {
  const AccountBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final userDataAsync = ref.watch(userInfoControllerProvider);
    final isSaving = ref.watch(settingsControllerProvider).isLoading;
    final settings = ref.read(settingsControllerProvider.notifier);

    return userDataAsync.when(
      loading: () => const SettingsShimmer(),
      error: (error, _) => YeetErrorState(
        message: 'Could not load your account: $error',
        onRetry: () =>
            ref.read(userInfoControllerProvider.notifier).fetchUserData(),
      ),
      data: (userInfo) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AccountHeaderCard(
            name: userInfo.name,
            email: userInfo.email,
            photoUrl: userInfo.profileImageUrl,
            onEditPhoto: isSaving
                ? null
                : () => pickAndCropProfileImage(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            icon: Icons.logout_rounded,
            label: 'Sign out',
            color: colors.error,
            trailingIcon: Icons.chevron_right,
            onTap: isSaving
                ? null
                : () async {
                    final confirmed = await showYeetConfirmDialog(
                      context,
                      title: 'Sign out?',
                      message:
                          "You'll need to sign in again to access your data.",
                      confirmLabel: 'Sign out',
                    );
                    if (confirmed) settings.logout();
                  },
          ),
          const SizedBox(height: AppSpacing.sm),
          const SettingsSectionLabel('Danger zone'),
          SettingsTile(
            icon: Icons.delete_forever_outlined,
            label: 'Delete Account',
            color: colors.error,
            isLoading: isSaving,
            onTap: () async {
              final confirmed = await showYeetConfirmDialog(
                context,
                title: 'Delete Account',
                message:
                    'This will permanently delete your account and all your fitness data. This action cannot be undone.',
                confirmLabel: 'Delete',
              );
              if (confirmed) settings.deleteAccount();
            },
          ),
        ],
      ),
    );
  }
}
