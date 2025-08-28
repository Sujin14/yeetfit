import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/model/admin_model.dart';

class AdminListItem extends StatelessWidget {
  final AdminModel admin;
  final VoidCallback onTap;

  const AdminListItem({super.key, required this.admin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: AppTheme.colors['primaryAccent']!.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundImage: CachedNetworkImageProvider(
                admin.profileImage.isNotEmpty
                    ? admin.profileImage
                    : 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              admin.name,
              style: AppTheme.textStyles['bodyMedium']?.copyWith(
                color: AppTheme.colors['onSurface'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
