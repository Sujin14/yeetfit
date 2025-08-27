import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class PlanTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const PlanTileWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: FixedSizes.box12(context),
          horizontal: FixedSizes.box16(context),
        ),
        decoration: BoxDecoration(
          color: AppTheme.colors['cardBackground'] ?? Colors.white,
          borderRadius: BorderRadius.circular(FixedSizes.radius12(context)),
          boxShadow: [
            BoxShadow(
              color: (AppTheme.colors['shadow'] ?? Colors.grey).withOpacity(
                0.1,
              ),
              blurRadius: FixedSizes.box8(context),
              offset: Offset(0, FixedSizes.box2(context)),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: FixedSizes.icon20(context),
              color: AppTheme.colors['primaryIcon'] ?? Colors.blue,
            ),
            SizedBox(width: FixedSizes.box16(context)),
            Text(
              title,
              style:
                  AppTheme.textStyles['body']?.copyWith(
                    color: AppTheme.colors['primaryText'] ?? Colors.black,
                    fontSize: FixedSizes.font18(context),
                    fontWeight: FontWeight.w500,
                  ) ??
                  TextStyle(
                    fontSize: FixedSizes.font18(context),
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
