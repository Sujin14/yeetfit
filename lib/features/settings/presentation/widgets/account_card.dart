import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
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
          padding: EdgeInsets.symmetric(vertical: 8.h),
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
                              fontSize: 18.sp,
                              color: AppTheme.colors['primaryText'],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Manage your account details',
                            style: AppTheme.textStyles['body']!.copyWith(
                              fontSize: 14.sp,
                              color: AppTheme.colors['secondaryText'],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.colors['primaryText'],
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
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
                              fontSize: 18.sp,
                              color: AppTheme.colors['error'],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Permanently delete your account',
                            style: AppTheme.textStyles['body']!.copyWith(
                              fontSize: 14.sp,
                              color: AppTheme.colors['secondaryText'],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.delete,
                      color: AppTheme.colors['error'],
                      size: 16.sp,
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