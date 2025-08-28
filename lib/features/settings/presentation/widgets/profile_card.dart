import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/data/models/user_info_model.dart';

class ProfileCard extends StatelessWidget {
  final UserInfoModel userInfo;
  final VoidCallback onEdit;

  const ProfileCard({
    super.key,
    required this.userInfo,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 200.w,
      height: 200.h,
      borderRadius: 16.r,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          AppTheme.colors['cardBackground']!.withOpacity(0.1),
          AppTheme.colors['cardBackground']!.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['borderGradientStart']!,
          AppTheme.colors['borderGradientEnd']!,
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundImage: userInfo.profileImageUrl != null
                    ? NetworkImage(userInfo.profileImageUrl!)
                    : const AssetImage('assets/images/default_profile.png')
                        as ImageProvider,
              ),
              SizedBox(height: 8.h),
              Text(
                userInfo.name.isNotEmpty ? userInfo.name : 'User Name',
                style: AppTheme.textStyles['subheading']!.copyWith(
                  fontSize: 18.sp,
                  color: AppTheme.colors['primaryText'],
                ),
              ),
              Text(
                (userInfo.email != null && userInfo.email!.isNotEmpty) ? userInfo.email! : 'user@example.com',
                style: AppTheme.textStyles['body']!.copyWith(
                  fontSize: 14.sp,
                  color: AppTheme.colors['secondaryText'],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: AppTheme.colors['primaryIcon'],
                size: 24.sp,
              ),
              onPressed: onEdit,
            ),
          ),
        ],
      ),
    );
  }
}