import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/presentation/providers/user_info_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.colors['lightBackground'],
        title: Text(
          'Delete Account',
          style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
        content: Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
          style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText'])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['error'])),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(userInfoControllerProvider.notifier).deleteUserData(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            // About Card
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
            // Account Card
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
                      onPressed: () => _deleteAccount(context, ref),
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
            // Logout Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colors['error'],
                  minimumSize: Size(double.infinity, 48.h),
                ),
                child: Text(
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