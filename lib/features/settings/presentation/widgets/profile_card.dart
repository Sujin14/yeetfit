import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/data/models/user_info_model.dart';

class ProfileCard extends StatelessWidget {
  final UserInfoModel userInfo;
  final VoidCallback onEdit;

  const ProfileCard({super.key, required this.userInfo, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundImage: userInfo.profileImageUrl != null
                  ? NetworkImage(userInfo.profileImageUrl!)
                  : const AssetImage('assets/images/profile_image_placeholder.png') as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.colors['primaryButton'],
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.colors['lightBackground']!, width: 2.w),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: AppTheme.colors['onSurfaceDark'],
                    size: 16.sp,
                  ),
                ),
              ),
            ),
          ],
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