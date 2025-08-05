import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/theme.dart';

class ProfileCard extends StatelessWidget {
  final UserInfo userInfo;

  const ProfileCard({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundImage: userInfo.photoURL != null
              ? NetworkImage(userInfo.photoURL!)
              : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
        ),
        SizedBox(height: 8.h),
        Text(
          (userInfo.displayName != null && userInfo.displayName!.isNotEmpty) ? userInfo.displayName! : 'User',
          style: AppTheme.textStyles['heading']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
      ],
    );
  }
}