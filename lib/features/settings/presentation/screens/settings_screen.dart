import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaving = ref.watch(settingsControllerProvider.notifier).isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassmorphicContainer(
              width: double.infinity,
              height: 350.h,
              borderRadius: 16.r,
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
                colors: [AppTheme.colors['gradientTextStart']!, AppTheme.colors['gradientTextEnd']!],
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: AppTheme.textStyles['subtitle']!.copyWith(
                        fontSize: 18.sp,
                        color: AppTheme.colors['primaryText'],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: () {}, // Placeholder for About
                      child: Text(
                        'About',
                        style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                      ),
                    ),
                    TextButton(
                      onPressed: () {}, // Placeholder for Help
                      child: Text(
                        'Help',
                        style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                      ),
                    ),
                    TextButton(
                      onPressed: () {}, // Placeholder for About Us
                      child: Text(
                        'About Us',
                        style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                      ),
                    ),
                    TextButton(
                      onPressed: () {}, // Placeholder for Terms & Conditions
                      child: Text(
                        'Terms & Conditions',
                        style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                      ),
                    ),
                    Text(
                      'App Version: 1.0.0',
                      style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GlassmorphicContainer(
              width: double.infinity,
              height: 200.h,
              borderRadius: 16.r,
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
                colors: [AppTheme.colors['gradientTextStart']!, AppTheme.colors['gradientTextEnd']!],
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
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
                    TextButton(
                      onPressed: () => context.push('/account'),
                      child: Text(
                        'Account',
                        style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                      ),
                    ),
                    TextButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              final success = await ref.read(settingsControllerProvider.notifier).deleteAccount(context);
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Account deleted successfully',
                                      style: AppTheme.textStyles['body']!.copyWith(
                                        color: AppTheme.colors['onSurfaceDark'],
                                      ),
                                    ),
                                    backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.green,
                                  ),
                                );
                              }
                            },
                      child: Text(
                        'Delete Account',
                        style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['error']),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Center(
              child: ElevatedButton(
                onPressed: isSaving
                    ? null
                    : () async {
                        final success = await ref.read(settingsControllerProvider.notifier).logout(context);
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Logged out successfully',
                                style: AppTheme.textStyles['body']!.copyWith(
                                  color: AppTheme.colors['onSurfaceDark'],
                                ),
                              ),
                              backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.green,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colors['error'],
                  minimumSize: Size(double.infinity, 48.h),
                ),
                child: isSaving
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
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
            ),
          ],
        ),
      ),
    );
  }
}