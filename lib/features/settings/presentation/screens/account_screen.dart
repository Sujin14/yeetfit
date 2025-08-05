import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/presentation/providers/user_info_controller.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userInfoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: userDataAsync.when(
        data: (userInfo) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundImage: userInfo.profileImageUrl != null
                      ? NetworkImage(userInfo.profileImageUrl!)
                      : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
                ),
                SizedBox(height: 8.h),
                Text(
                  userInfo.name.isNotEmpty ? userInfo.name : 'User',
                  style: AppTheme.textStyles['heading']!.copyWith(color: AppTheme.colors['primaryText']),
                ),
                SizedBox(height: 24.h),
                // Basic Information Card
                GestureDetector(
                  onTap: () => context.push('/basic-information'),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 100.h,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Basic Information',
                            style: AppTheme.textStyles['subtitle']!.copyWith(
                              fontSize: 18.sp,
                              color: AppTheme.colors['primaryText'],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Height, Weight, Age, Gender, Activity',
                            style: AppTheme.textStyles['body']!.copyWith(
                              fontSize: 14.sp,
                              color: AppTheme.colors['secondaryText'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Primary Goal Card
                GestureDetector(
                  onTap: () => context.push('/goal-settings'),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 100.h,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Primary Goal',
                            style: AppTheme.textStyles['subtitle']!.copyWith(
                              fontSize: 18.sp,
                              color: AppTheme.colors['primaryText'],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            userInfo.goal.isNotEmpty ? userInfo.goal : 'Not set',
                            style: AppTheme.textStyles['body']!.copyWith(
                              fontSize: 14.sp,
                              color: AppTheme.colors['secondaryText'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Food Preferences Card
                GestureDetector(
                  onTap: () => context.push('/food-preferences'),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 100.h,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Food Preferences',
                            style: AppTheme.textStyles['subtitle']!.copyWith(
                              fontSize: 18.sp,
                              color: AppTheme.colors['primaryText'],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Diet Preferences, Allergies, Cuisine',
                            style: AppTheme.textStyles['body']!.copyWith(
                              fontSize: 14.sp,
                              color: AppTheme.colors['secondaryText'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error: $error',
            style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
          ),
        ),
      ),
    );
  }
}