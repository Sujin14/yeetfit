import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../data/model/admin_model.dart';
import '../controllers/admin_controller.dart';

class AdminListItem extends StatelessWidget {
  final AdminModel admin;
  final AdminController controller;

  const AdminListItem({super.key, required this.admin, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.selectAdmin(context, admin.id),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: FixedSizes.box16(context),
          vertical: FixedSizes.box12(context),
        ),
        margin: EdgeInsets.symmetric(vertical: FixedSizes.box4(context)),
        decoration: BoxDecoration(
          color: AppTheme.colors['primaryAccent']!.withOpacity(0.1),
          borderRadius: BorderRadius.circular(FixedSizes.radius12(context)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: FixedSizes.box25(context),
              backgroundImage: CachedNetworkImageProvider(
                admin.profileImage.isNotEmpty
                    ? admin.profileImage
                    : 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
              ),
            ),
            SizedBox(width: FixedSizes.box12(context)),
            Text(
              admin.name,
              style: AppTheme.textStyles['bodyLarge']?.copyWith(
                color: AppTheme.colors['onSurface'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
