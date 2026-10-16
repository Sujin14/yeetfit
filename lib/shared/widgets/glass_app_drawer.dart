import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/auth_route_constants.dart';
import 'package:yeetfit/core/services/notification_service.dart';
import 'package:yeetfit/core/routes/settings_route_constants.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/profile/pick_and_crop_profile_image.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/providers/user_document_provider.dart';
import 'package:yeetfit/shared/widgets/drawer_profile_avatar.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/yeet_confirm_dialog.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Side drawer for the app shell with profile header, links and sign out.
class GlassAppDrawer extends ConsumerWidget {
  const GlassAppDrawer({super.key});

  void _openRoute(BuildContext context, String route) {
    Navigator.pop(context);
    context.push(route);
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showYeetConfirmDialog(
      context,
      title: 'Sign out?',
      message: "You'll need to sign in again to access your data.",
      confirmLabel: 'Sign out',
    );
    if (!confirmed) return;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await ref.read(notificationServiceProvider).onSignOut(userId);
    }
    await FirebaseAuth.instance.signOut();
    if (context.mounted) context.go(AuthRouteConstants.root);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final user =
        ref.watch(currentUserProvider).value ??
        FirebaseAuth.instance.currentUser;
    final profile = user == null
        ? null
        : ref.watch(userDocumentProvider(user.uid)).value;
    final name = (profile?['name'] as String?) ?? user?.displayName ?? 'User';
    final highlight = Colors.white.withValues(alpha: 0.08);

    Widget link(IconData icon, String label, String route) => ListTile(
      leading: Icon(icon),
      title: Text(label),
      iconColor: colors.textSecondary,
      textColor: colors.onBackground,
      hoverColor: highlight,
      splashColor: highlight,
      focusColor: highlight,
      onTap: () => _openRoute(context, route),
    );

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: ShellGradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                borderRadius: 0,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => pickAndCropProfileImage(context),
                      child: DrawerProfileAvatar(
                        name: name,
                        profileImageUrl: profile?['profileImageUrl'] as String?,
                        authPhotoUrl: user?.photoURL,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge!.copyWith(
                              color: colors.onBackground,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            user?.email ?? 'No email',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall!.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0.5,
                thickness: 0.5,
                color: Colors.white.withValues(alpha: 0.15),
              ),
              const SizedBox(height: AppSpacing.sm),
              link(
                Icons.settings_outlined,
                'Settings',
                SettingsRouteConstants.root,
              ),
              link(
                Icons.person_outline,
                'Account',
                SettingsRouteConstants.account,
              ),
              link(
                Icons.help_outline,
                'Help & Support',
                SettingsRouteConstants.help,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _signOut(context, ref),
                  child: GlassCard(
                    borderRadius: 12,
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: colors.error),
                        const SizedBox(width: AppSpacing.smd),
                        Text(
                          'Sign out',
                          style: textTheme.titleMedium!.copyWith(
                            color: colors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
