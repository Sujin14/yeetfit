import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
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
              radius: FixedSizes.radius50(context),
              backgroundImage: userInfo.profileImageUrl != null
                  ? NetworkImage(userInfo.profileImageUrl!)
                  : const AssetImage(
                          'assets/images/profile_image_placeholder.png',
                        )
                        as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.all(FixedSizes.box4(context)),
                  decoration: BoxDecoration(
                    color: AppTheme.colors['primaryButton'],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.colors['lightBackground']!,
                      width: FixedSizes.box2(context),
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: AppTheme.colors['onSurfaceDark'],
                    size: FixedSizes.font16(context),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: FixedSizes.box8(context)),
        Text(
          userInfo.name.isNotEmpty ? userInfo.name : 'User',
          style: AppTheme.textStyles['heading']!.copyWith(
            color: AppTheme.colors['primaryText'],
          ),
        ),
      ],
    );
  }
}
