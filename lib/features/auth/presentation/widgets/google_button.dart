import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/button_spinner.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../providers/auth_providers.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/auth_strings.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class GoogleButton extends ConsumerWidget {
  static const double _height = 52;
  static const double _radius = 16;

  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isLoading = ref.watch(googleAuthControllerProvider);

    return SizedBox(
      height: _height,
      child: GlassCard(
        borderRadius: _radius,
        padding: EdgeInsets.zero,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: isLoading
                ? null
                : () async {
                    final result = await ref
                        .read(googleAuthControllerProvider.notifier)
                        .loginWithGoogle();
                    if (!context.mounted) return;
                    handleAuthResult(
                      context,
                      result,
                      AuthStrings.googleSignInFailed,
                    );
                  },
            child: Center(
              child: isLoading
                  ? ButtonSpinner(color: colors.primary)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/google.png',
                          width: 32,
                          cacheWidth: 96,
                        ),
                        const SizedBox(width: AppSpacing.smd),
                        Text(
                          'Continue with Google',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: colors.onBackground),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
