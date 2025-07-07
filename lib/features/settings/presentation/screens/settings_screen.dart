import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/custom_appbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _handleLogout(BuildContext context) {
    // Placeholder logout logic; replace with actual authentication logic
    debugPrint('User logged out');
    context.go('/login'); // Navigate to login screen (adjust route as needed)
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Logout',
          style: AppTheme.textStyles['title']!.copyWith(
            fontSize: 18.sp,
            color: AppTheme.colors['primaryText'],
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: AppTheme.textStyles['body']!.copyWith(
            fontSize: 16.sp,
            color: AppTheme.colors['secondaryText'],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: Text(
              'Cancel',
              style: AppTheme.textStyles['body']!.copyWith(
                fontSize: 14.sp,
                color: AppTheme.colors['secondaryText'],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _handleLogout(context); // Perform logout
            },
            child: Text(
              'Confirm',
              style: AppTheme.textStyles['body']!.copyWith(
                fontSize: 14.sp,
                color: AppTheme.colors['error'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Settings', showSettings: false),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showLogoutConfirmationDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.colors['error'] ?? Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Log Out',
            style: AppTheme.textStyles['body']!.copyWith(
              fontSize: 16.sp,
              color: AppTheme.colors['primaryText'] ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
