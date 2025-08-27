import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/settings_provider.dart';

class AccountCard extends ConsumerWidget {
  final VoidCallback onAccountTap;
  final VoidCallback onDeleteTap;

  const AccountCard({
    super.key,
    required this.onAccountTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaving = ref.watch(settingsControllerProvider.notifier).isSaving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: FixedSizes.box8(context)),
          child: Column(
            children: [
              GestureDetector(
                onTap: onAccountTap,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account',
                            style: AppTheme.textStyles['subtitle']!.copyWith(
                              fontSize: FixedSizes.font18(context),
                              color: AppTheme.colors['primaryText'],
                            ),
                          ),
                          SizedBox(height: FixedSizes.box8(context)),
                          Text(
                            'Manage your account details',
                            style: AppTheme.textStyles['body']!.copyWith(
                              fontSize: FixedSizes.font14(context),
                              color: AppTheme.colors['secondaryText'],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.colors['primaryText'],
                      size: FixedSizes.icon16(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: FixedSizes.box16(context)),
              GestureDetector(
                onTap: isSaving ? null : onDeleteTap,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delete Account',
                            style: AppTheme.textStyles['subtitle']!.copyWith(
                              fontSize: FixedSizes.font18(context),
                              color: AppTheme.colors['error'],
                            ),
                          ),
                          SizedBox(height: FixedSizes.box8(context)),
                          Text(
                            'Permanently delete your account',
                            style: AppTheme.textStyles['body']!.copyWith(
                              fontSize: FixedSizes.font14(context),
                              color: AppTheme.colors['secondaryText'],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.delete,
                      color: AppTheme.colors['error'],
                      size: FixedSizes.icon16(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
