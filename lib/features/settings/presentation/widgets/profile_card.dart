import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/data/models/user_info_model.dart';

class ProfileCard extends StatelessWidget {
  final UserInfoModel userInfo;

  const ProfileCard({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundImage: userInfo.profileImageUrl != null
              ? NetworkImage(userInfo.profileImageUrl!)
              : const AssetImage('assets/images/profile_image_placeholder.png') as ImageProvider,
        ),
        SizedBox(height: 8.h),
        Text(
          userInfo.name.isNotEmpty ? userInfo.name : 'User',
          style: AppTheme.textStyles['heading']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
      ],
    );
  }
}