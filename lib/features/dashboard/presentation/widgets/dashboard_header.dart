import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_steps.dart';
import 'package:yeetfit/core/walkthrough/yana_showcase.dart';
import 'package:yeetfit/shared/profile/pick_and_crop_profile_image.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import '../providers/selected_date_provider.dart';
import 'package:yeetfit/shared/providers/user_document_provider.dart';
import 'dashboard_avatar.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Time-of-day greeting, the selected date, the Yana (AI coach) shortcut and the
/// user's avatar.
class DashboardHeader extends ConsumerWidget {
  final VoidCallback onOpenChatbot;

  const DashboardHeader({super.key, required this.onOpenChatbot});

  static String _greeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(currentUserProvider).value;
    final profile = user == null
        ? null
        : ref.watch(userDocumentProvider(user.uid)).value;
    final selectedDate = ref.watch(selectedDateProvider);

    // Email sign-ups store their name and photo in Firestore, not on the
    // auth profile, so Firestore takes precedence.
    final fullName =
        (profile?['name'] as String?) ??
        user?.displayName ??
        user?.email?.split('@').first ??
        '';
    final firstName = fullName.trim().split(RegExp(r'\s+')).first;
    final photoUrl = (profile?['profileImageUrl'] as String?) ?? user?.photoURL;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(DateTime.now().hour),
                  style: textTheme.headlineMedium!.copyWith(
                    color: colors.onBackground,
                  ),
                ),
                if (firstName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    firstName,
                    style: textTheme.headlineMedium!.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  DateFormat('EEEE, d MMM').format(selectedDate),
                  style: textTheme.bodyMedium!.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.smd),
          YanaShowcase(
            step: DashboardTour.yanaChat,
            child: GlassIconButton(
              icon: Icons.auto_awesome,
              color: colors.secondary,
              tooltip: 'Chat with Yana',
              onPressed: onOpenChatbot,
            ),
          ),
          const SizedBox(width: AppSpacing.smd),
          DashboardAvatar(
            name: fullName,
            photoUrl: photoUrl,
            onTap: () => pickAndCropProfileImage(context),
          ),
        ],
      ),
    );
  }
}
