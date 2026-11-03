import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/shared/widgets/empty_state_image.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';

/// Empty / unavailable coach-chat gate — no glass container (matches Explore).
class CoachChatGateEmpty extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback onFindCoach;

  const CoachChatGateEmpty({
    super.key,
    required this.title,
    required this.body,
    required this.onFindCoach,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.smd,
              AppSpacing.sm,
              AppSpacing.smd,
              0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: YeetBackButton(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, AppSpacing.xl, 20, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyStateImage(
                    assetPath: 'assets/images/empty_coaches.webp',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge!.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium!.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: onFindCoach,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.smd,
                      ),
                    ),
                    child: const Text('Find a coach'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
